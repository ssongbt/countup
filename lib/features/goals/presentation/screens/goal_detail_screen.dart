import 'package:countup/features/goals/presentation/providers/goal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GoalDetailScreen extends ConsumerWidget {
  const GoalDetailScreen({
    required this.goalId,
    super.key,
  });

  final String goalId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goal = ref.watch(goalByIdProvider(goalId));
    final notifier = ref.read(goalsProvider.notifier);

    if (goal == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('목표 상세')),
        body: const Center(child: Text('목표를 찾을 수 없습니다.')),
      );
    }

    final canUndo = notifier.canUndo(goalId);
    final isCompleted = goal.isCompleted;

    return Scaffold(
      appBar: AppBar(title: Text(goal.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${goal.currentCount} / ${goal.targetCount}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(value: goal.progress),
            const SizedBox(height: 12),
            Text(
              '남은 횟수: ${goal.remainingCount}',
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: isCompleted
                  ? null
                  : () async {
                      await notifier.increment(goalId);
                      final updated = ref.read(goalByIdProvider(goalId));
                      if (updated != null && updated.isCompleted && context.mounted) {
                        await showDialog<void>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('완료!'),
                            content: Text('${updated.title} 목표를 달성했습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
              icon: const Icon(Icons.add),
              label: const Text('+1'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: canUndo ? () => notifier.undo(goalId) : null,
              child: const Text('Undo'),
            ),
          ],
        ),
      ),
    );
  }
}
