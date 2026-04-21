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
                child: ListTile(
                  onTap: () => context.go('/goal/${goal.id}'),
                  title: Text(goal.title),
                  subtitle: Text('${goal.currentCount}/${goal.targetCount}'),
                  trailing: Text('${(goal.progress * 100).round()}%'),
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
