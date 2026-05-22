import 'package:countup/core/routing/app_routes.dart';
import 'package:countup/features/goals/presentation/providers/home_tab_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeBottomNavigationBar extends ConsumerWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(homeTabIndexProvider);

    return BottomNavigationBar(
      currentIndex: tabIndex,
      onTap: (index) {
        ref.read(homeTabIndexProvider.notifier).state = index;
        final location = GoRouterState.of(context).uri.path;
        if (location != AppRoutes.home) {
          context.go(AppRoutes.home);
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_outlined),
          activeIcon: Icon(Icons.trending_up),
          label: '진행중',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check_circle_outline),
          activeIcon: Icon(Icons.check_circle),
          label: '완료',
        ),
      ],
    );
  }
}
