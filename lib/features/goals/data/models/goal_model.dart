import 'package:countup/features/goals/domain/entities/goal.dart';

class GoalModel {
  GoalModel({
    required this.id,
    required this.title,
    required this.targetCount,
    required this.currentCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.visualType,
    this.completedAt,
  });

  final String id;
  final String title;
  final int targetCount;
  final int currentCount;
  final GoalStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;
  final GoalVisualType visualType;

  Goal toDomain() {
    return Goal(
      id: id,
      title: title,
      targetCount: targetCount,
      currentCount: currentCount,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
      completedAt: completedAt,
      visualType: visualType,
    );
  }

  static GoalModel fromDomain(Goal goal) {
    return GoalModel(
      id: goal.id,
      title: goal.title,
      targetCount: goal.targetCount,
      currentCount: goal.currentCount,
      status: goal.status,
      createdAt: goal.createdAt,
      updatedAt: goal.updatedAt,
      completedAt: goal.completedAt,
      visualType: goal.visualType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'targetCount': targetCount,
      'currentCount': currentCount,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'visualType': visualType.name,
    };
  }

  static GoalModel fromMap(Map<dynamic, dynamic> map) {
    GoalStatus parseStatus(String value) {
      return GoalStatus.values.firstWhere(
        (e) => e.name == value,
        orElse: () => GoalStatus.active,
      );
    }

    GoalVisualType parseVisual(String value) {
      return GoalVisualType.values.firstWhere(
        (e) => e.name == value,
        orElse: () => GoalVisualType.dots,
      );
    }

    return GoalModel(
      id: map['id'] as String,
      title: map['title'] as String,
      targetCount: map['targetCount'] as int,
      currentCount: map['currentCount'] as int,
      status: parseStatus((map['status'] as String?) ?? 'active'),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
      completedAt: map['completedAt'] == null
          ? null
          : DateTime.parse(map['completedAt'] as String),
      visualType: parseVisual((map['visualType'] as String?) ?? 'dots'),
    );
  }
}
