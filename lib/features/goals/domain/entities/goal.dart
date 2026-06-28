enum GoalStatus {
  active,
  completed,
  archived,
}

enum GoalVisualType {
  dots,
  blocks,
  circle,
}

class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.targetCount,
    required this.currentCount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.visualType,
    this.completedAt,
    this.countLog = const [],
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

  /// 1회씩 카운트업한 시각의 기록 (오래된 순)
  final List<DateTime> countLog;

  double get progress {
    if (targetCount <= 0) {
      return 0;
    }
    return (currentCount.clamp(0, targetCount) / targetCount).toDouble();
  }

  int get remainingCount {
    final remaining = targetCount - currentCount;
    return remaining < 0 ? 0 : remaining;
  }

  bool get isCompleted => status == GoalStatus.completed;
}
