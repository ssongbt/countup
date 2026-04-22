import 'package:countup/features/goals/presentation/providers/goal_providers.dart';
import 'package:countup/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(
        leading: IconButton(
          tooltip: '뒤로가기',
          onPressed: () {
            if (context.canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutes.home);
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(goal.title),
        actions: [
          IconButton(
            tooltip: '홈으로',
            onPressed: () => context.go(AppRoutes.home),
            icon: const Icon(Icons.home_outlined),
          ),
          IconButton(
            tooltip: '삭제',
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('목표를 삭제할까요?'),
                  content: const Text('삭제 후에는 복구할 수 없어요.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      child: const Text('취소'),
                    ),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      child: const Text('삭제'),
                    ),
                  ],
                ),
              );
              if (shouldDelete != true || !context.mounted) {
                return;
              }
              await notifier.deleteGoal(goalId);
              if (context.mounted) {
                context.go(AppRoutes.home);
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${goal.currentCount} / ${goal.targetCount}',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineMedium?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SquareProgressGrid(
                    currentCount: goal.currentCount,
                    targetCount: goal.targetCount,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '남은 횟수: ${goal.remainingCount}',
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
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
              label: const Text('+1'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: canUndo ? () => notifier.undo(goalId) : null,
              child: const Text('-1'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SquareProgressGrid extends StatelessWidget {
  const _SquareProgressGrid({
    required this.currentCount,
    required this.targetCount,
  });

  final int currentCount;
  final int targetCount;

  @override
  Widget build(BuildContext context) {
    if (targetCount <= 0) {
      return const SizedBox.shrink();
    }

    final filledCount = currentCount.clamp(0, targetCount);
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Row(
          children: List.generate(targetCount, (index) {
            final filled = index < filledCount;
            final isLast = index == targetCount - 1;
            return Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  color: filled ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                  border: isLast
                      ? null
                      : Border(
                          right: BorderSide(
                            color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                          ),
                        ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
