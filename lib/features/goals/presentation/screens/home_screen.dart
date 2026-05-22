import 'package:countup/core/routing/app_routes.dart';
import 'package:countup/features/goals/domain/entities/goal.dart';
import 'package:countup/features/goals/presentation/providers/goal_providers.dart';
import 'package:countup/features/goals/presentation/providers/home_tab_provider.dart';
import 'package:countup/features/goals/presentation/widgets/home_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _emptyMessage({
    required bool hasAnyGoals,
    required bool showingCompleted,
  }) {
    if (!hasAnyGoals) {
      return '목표를 추가해보세요.';
    }
    if (showingCompleted) {
      return '완료한 목표가 없어요.';
    }
    return '진행 중인 목표가 없어요.';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(homeTabIndexProvider);
    final goalsState = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'COUNTUP',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: goalsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류: $error')),
        data: (goals) {
          final activeGoals =
              goals.where((goal) => !goal.isCompleted).toList();
          final completedGoals =
              goals.where((goal) => goal.isCompleted).toList();
          final showingCompleted = tabIndex == 1;
          final displayedGoals =
              showingCompleted ? completedGoals : activeGoals;

          if (displayedGoals.isEmpty) {
            return Center(
              child: Text(
                _emptyMessage(
                  hasAnyGoals: goals.isNotEmpty,
                  showingCompleted: showingCompleted,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: displayedGoals.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _GoalCard(
                goal: displayedGoals[index],
                isCompleted: showingCompleted,
              );
            },
          );
        },
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.create),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.goal,
    this.isCompleted = false,
  });

  final Goal goal;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: isCompleted
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
          : null,
      child: InkWell(
        onTap: () => context.push('/goal/${goal.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (isCompleted) ...[
                    Icon(
                      Icons.check_circle_outline,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      goal.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    isCompleted
                        ? '완료'
                        : '진행률 ${(goal.progress * 100).round()}%',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                '${goal.currentCount}/${goal.targetCount}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: isCompleted ? 1 : goal.progress,
                  minHeight: 10,
                  backgroundColor:
                      colorScheme.outlineVariant.withValues(alpha: 0.35),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted
                        ? colorScheme.primary.withValues(alpha: 0.7)
                        : colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
