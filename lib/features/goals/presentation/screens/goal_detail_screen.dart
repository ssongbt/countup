import 'package:countup/features/goals/domain/entities/goal.dart';
import 'package:countup/features/goals/presentation/providers/goal_providers.dart';
import 'package:countup/features/goals/presentation/providers/home_tab_provider.dart';
import 'package:countup/features/goals/presentation/widgets/home_bottom_navigation_bar.dart';
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
        bottomNavigationBar: const HomeBottomNavigationBar(),
      );
    }

    final canDecrement = goal.currentCount > 0;
    final isCompleted = goal.isCompleted;

    Future<void> handleIncrement() async {
      if (isCompleted) {
        return;
      }
      await notifier.increment(goalId);
      final updated = ref.read(goalByIdProvider(goalId));
      if (updated != null && updated.isCompleted && context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('완료!'),
            content: Text('${updated.title} 목표를 달성했습니다.🎉'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: '뒤로가기',
          onPressed: () => _handleBack(context, ref, goal.isCompleted),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: Text(goal.title),
        actions: [
          IconButton(
            tooltip: '수정',
            onPressed: () => _showEditGoalDialog(context, ref, goal),
            icon: const Icon(Icons.edit_outlined),
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
                if (goal.isCompleted) {
                  ref.read(homeTabIndexProvider.notifier).state = 1;
                }
                _navigateToHome(context);
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            _ThinProgressBar(
              currentCount: goal.currentCount,
              targetCount: goal.targetCount,
            ),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: isCompleted ? null : handleIncrement,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${goal.currentCount}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 72,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '남은 횟수 ${goal.remainingCount}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filledTonal(
                    tooltip: '1회 줄이기',
                    onPressed:
                        canDecrement ? () => notifier.decrement(goalId) : null,
                    iconSize: 32,
                    icon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  IconButton.filled(
                    tooltip: '1회 추가',
                    onPressed: isCompleted ? null : handleIncrement,
                    iconSize: 32,
                    icon: const Icon(Icons.keyboard_arrow_up),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const HomeBottomNavigationBar(),
    );
  }
}

void _handleBack(BuildContext context, WidgetRef ref, bool isCompletedGoal) {
  if (isCompletedGoal) {
    ref.read(homeTabIndexProvider.notifier).state = 1;
  }
  _navigateToHome(context);
}

void _navigateToHome(BuildContext context) {
  if (context.canPop()) {
    context.pop();
    return;
  }
  context.go(AppRoutes.home);
}

Future<void> _showEditGoalDialog(
  BuildContext context,
  WidgetRef ref,
  Goal goal,
) async {
  final result = await showDialog<_EditGoalResult>(
    context: context,
    builder: (_) => _EditGoalDialog(goal: goal),
  );

  if (result == null) {
    return;
  }

  await ref.read(goalsProvider.notifier).updateGoalDetails(
        goalId: goal.id,
        title: result.title,
        targetCount: result.targetCount,
      );
}

class _EditGoalResult {
  const _EditGoalResult({
    required this.title,
    required this.targetCount,
  });

  final String title;
  final int targetCount;
}

class _EditGoalDialog extends StatefulWidget {
  const _EditGoalDialog({required this.goal});

  final Goal goal;

  @override
  State<_EditGoalDialog> createState() => _EditGoalDialogState();
}

class _EditGoalDialogState extends State<_EditGoalDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _targetController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.goal.title);
    _targetController =
        TextEditingController(text: '${widget.goal.targetCount}');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState?.validate() != true) {
      return;
    }
    Navigator.of(context).pop(
      _EditGoalResult(
        title: _titleController.text,
        targetCount: int.parse(_targetController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('목표 수정'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              maxLength: 30,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '목표',
                hintText: '예: 헬스 13번 가기',
              ),
              validator: (value) {
                final text = value?.trim() ?? '';
                if (text.isEmpty) {
                  return '목표를 입력해주세요.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _targetController,
              decoration: const InputDecoration(
                labelText: '목표 횟수',
                hintText: '예: 13',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                final parsed = int.tryParse(value ?? '');
                if (parsed == null || parsed < 1 || parsed > 999) {
                  return '1~999 사이 숫자를 입력해주세요.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('취소'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('저장'),
        ),
      ],
    );
  }
}

class _ThinProgressBar extends StatelessWidget {
  const _ThinProgressBar({
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
    final progress = filledCount / targetCount;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: SizedBox(
            height: 4,
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: colorScheme.surfaceContainerHighest,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '$targetCount',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
