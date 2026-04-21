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
      appBar: AppBar(title: const Text('CountUp')),
      body: goalsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('오류: $error')),
        data: (goals) {
          if (goals.isEmpty) {
            return const Center(child: Text('목표를 추가해보세요.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final goal = goals[index];
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
                            Text('${(goal.progress * 100).round()}%'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${goal.currentCount}/${goal.targetCount} · 남은 ${goal.remainingCount}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 10),
                        _BlockGauge(progress: goal.progress),
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

class _BlockGauge extends StatelessWidget {
  const _BlockGauge({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    const totalBlocks = 12;
    final filledCount = (progress * totalBlocks).round().clamp(0, totalBlocks);
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: List.generate(totalBlocks, (index) {
        final filled = index < filledCount;
        return Expanded(
          child: Container(
            height: 12,
            margin: EdgeInsets.only(right: index == totalBlocks - 1 ? 0 : 4),
            decoration: BoxDecoration(
              color: filled ? colorScheme.primary : colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        );
      }),
    );
  }
}
