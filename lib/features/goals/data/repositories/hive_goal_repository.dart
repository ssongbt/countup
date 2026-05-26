import 'package:countup/features/goals/data/models/goal_model.dart';
import 'package:countup/features/goals/domain/entities/goal.dart';
import 'package:countup/features/goals/domain/repositories/goal_repository.dart';
import 'package:hive/hive.dart';

class HiveGoalRepository implements GoalRepository {
  HiveGoalRepository(this._box);

  final Box<Map> _box;

  @override
  Future<void> createGoal(Goal goal) async {
    final model = GoalModel.fromDomain(goal);
    await _box.put(goal.id, model.toMap());
  }

  @override
  Future<void> deleteGoal(String id) async {
    await _box.delete(id);
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    final raw = _box.get(id);
    if (raw == null) {
      return null;
    }
    return GoalModel.fromMap(raw).toDomain();
  }

  @override
  Future<List<Goal>> getGoals() async {
    final goals = _box.values
        .map((raw) => GoalModel.fromMap(raw).toDomain())
        .toList();
    goals.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return goals;
  }

  @override
  Future<void> updateGoal(Goal goal) async {
    final updated = GoalModel.fromDomain(goal);
    await _box.put(goal.id, updated.toMap());
  }

  @override
  Future<void> increment(String id) async {
    final goal = await getGoalById(id);
    if (goal == null || goal.status == GoalStatus.completed) {
      return;
    }
    final nextCount = (goal.currentCount + 1).clamp(0, goal.targetCount);
    final isCompleted = nextCount >= goal.targetCount;
    final updated = Goal(
      id: goal.id,
      title: goal.title,
      targetCount: goal.targetCount,
      currentCount: nextCount,
      status: isCompleted ? GoalStatus.completed : GoalStatus.active,
      createdAt: goal.createdAt,
      updatedAt: DateTime.now(),
      completedAt: isCompleted ? DateTime.now() : null,
      visualType: goal.visualType,
    );
    await updateGoal(updated);
  }

  @override
  Future<void> decrement(String id) async {
    final goal = await getGoalById(id);
    if (goal == null || goal.currentCount <= 0) {
      return;
    }
    final nextCount = goal.currentCount - 1;
    final updated = Goal(
      id: goal.id,
      title: goal.title,
      targetCount: goal.targetCount,
      currentCount: nextCount,
      status: GoalStatus.active,
      createdAt: goal.createdAt,
      updatedAt: DateTime.now(),
      completedAt: null,
      visualType: goal.visualType,
    );
    await updateGoal(updated);
  }
}
