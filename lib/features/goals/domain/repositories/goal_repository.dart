import 'package:countup/features/goals/domain/entities/goal.dart';

abstract class GoalRepository {
  Future<List<Goal>> getGoals();
  Future<Goal?> getGoalById(String id);
  Future<void> createGoal(Goal goal);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(String id);
  Future<void> increment(String id);
  Future<void> undoLastIncrement(String id);
}
