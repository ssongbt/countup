import 'package:countup/core/routing/app_routes.dart';
import 'package:countup/features/goals/presentation/providers/goal_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          if (goals.isEmpty) {
            return const Center(child: Text('목표를 추가해보세요.'));
          }
          final sortedGoals = [...goals]
            ..sort((a, b) => a.isCompleted == b.isCompleted
                ? 0
                : (a.isCompleted ? 1 : -1));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: sortedGoals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = sortedGoals[index];
              return Card(
                child: InkWell(
                  onTap: () => context.go('/goal/${goal.id}'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                goal.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Text('진행률 ${(goal.progress * 100).round()}%'),
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
                            value: goal.progress,
                            minHeight: 10,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.outlineVariant.withValues(alpha: 0.35),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRoutes.create),
        child: const Icon(Icons.add),
      ),
    );
  }
}
