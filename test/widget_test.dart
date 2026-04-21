import 'package:countup/features/goals/domain/entities/goal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Goal progress and remaining count works', () {
    final goal = Goal(
      id: 'goal-1',
      title: '헬스 13번',
      targetCount: 13,
      currentCount: 7,
      status: GoalStatus.active,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
      completedAt: null,
      visualType: GoalVisualType.dots,
    );

    expect(goal.progress, closeTo(7 / 13, 0.00001));
    expect(goal.remainingCount, 6);
    expect(goal.isCompleted, false);
  });
}
