import 'package:countup/core/db/hive_provider.dart';
import 'package:countup/core/utils/kst_time.dart';
import 'package:countup/features/goals/data/repositories/hive_goal_repository.dart';
import 'package:countup/features/goals/domain/entities/goal.dart';
import 'package:countup/features/goals/domain/repositories/goal_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  final box = ref.watch(hiveBoxProvider).value;
  if (box == null) {
    throw StateError('Hive is not initialized yet.');
  }
  return HiveGoalRepository(box);
});

final goalsProvider = AsyncNotifierProvider<GoalsNotifier, List<Goal>>(
  GoalsNotifier.new,
);

final goalByIdProvider = Provider.family<Goal?, String>((ref, id) {
  final goalsState = ref.watch(goalsProvider);
  return goalsState.valueOrNull?.where((goal) => goal.id == id).firstOrNull;
});

class GoalsNotifier extends AsyncNotifier<List<Goal>> {
  @override
  Future<List<Goal>> build() async {
    return ref.read(goalRepositoryProvider).getGoals();
  }

  Future<void> refreshGoals() async {
    state = const AsyncLoading<List<Goal>>().copyWithPrevious(state);
    state = await AsyncValue.guard(() => ref.read(goalRepositoryProvider).getGoals());
  }

  Future<void> createGoal({
    required String title,
    required int targetCount,
  }) async {
    final now = kstNow();
    final goal = Goal(
      id: const Uuid().v4(),
      title: title.trim(),
      targetCount: targetCount,
      currentCount: 0,
      status: GoalStatus.active,
      createdAt: now,
      updatedAt: now,
      completedAt: null,
      visualType: GoalVisualType.dots,
      countLog: const [],
    );
    await ref.read(goalRepositoryProvider).createGoal(goal);
    await refreshGoals();
  }

  Future<void> increment(String goalId) async {
    await ref.read(goalRepositoryProvider).increment(goalId);
    await refreshGoals();
  }

  Future<void> decrement(String goalId) async {
    await ref.read(goalRepositoryProvider).decrement(goalId);
    await refreshGoals();
  }

  Future<void> updateGoalDetails({
    required String goalId,
    required String title,
    required int targetCount,
  }) async {
    final goal = state.valueOrNull?.where((g) => g.id == goalId).firstOrNull;
    if (goal == null) {
      return;
    }

    final clampedTarget = targetCount.clamp(1, 999);
    final clampedCurrent = goal.currentCount.clamp(0, clampedTarget);
    final isCompleted = clampedCurrent >= clampedTarget;
    final clampedLog = goal.countLog.length > clampedCurrent
        ? goal.countLog.sublist(0, clampedCurrent)
        : goal.countLog;

    final updated = Goal(
      id: goal.id,
      title: title.trim(),
      targetCount: clampedTarget,
      currentCount: clampedCurrent,
      status: isCompleted ? GoalStatus.completed : GoalStatus.active,
      createdAt: goal.createdAt,
      updatedAt: kstNow(),
      completedAt: isCompleted ? (goal.completedAt ?? kstNow()) : null,
      visualType: goal.visualType,
      countLog: clampedLog,
    );
    await ref.read(goalRepositoryProvider).updateGoal(updated);
    await refreshGoals();
  }

  Future<void> deleteGoal(String goalId) async {
    await ref.read(goalRepositoryProvider).deleteGoal(goalId);
    await refreshGoals();
  }
}
