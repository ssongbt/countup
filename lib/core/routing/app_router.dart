import 'package:countup/core/routing/app_routes.dart';
import 'package:countup/features/goals/presentation/screens/create_goal_screen.dart';
import 'package:countup/features/goals/presentation/screens/goal_detail_screen.dart';
import 'package:countup/features/goals/presentation/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.create,
      builder: (context, state) => const CreateGoalScreen(),
    ),
    GoRoute(
      path: AppRoutes.goalDetail,
      builder: (context, state) {
        final id = state.pathParameters['id'] ?? '';
        return GoalDetailScreen(goalId: id);
      },
    ),
  ],
);
