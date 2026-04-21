import 'package:countup/core/db/hive_provider.dart';
import 'package:countup/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: CountUpApp()));
}

class CountUpApp extends ConsumerWidget {
  const CountUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbState = ref.watch(hiveBoxProvider);
    const colorScheme = ColorScheme.light(
      primary: Color(0xFFAF95F9),
      secondary: Color(0xFFFFAAA5),
      surface: Color(0xFFFDF8FF),
      onPrimary: Colors.white,
      onSecondary: Color(0xFF5A1E2A),
      onSurface: Color(0xFF2D1E4A),
    );

    return MaterialApp.router(
      title: 'CountUp',
      theme: ThemeData(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFAF95F9),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFAAA5),
          foregroundColor: Color(0xFF5A1E2A),
        ),
      ),
      routerConfig: appRouter,
      builder: (context, child) {
        return dbState.when(
          data: (_) => child ?? const SizedBox.shrink(),
          loading: () => const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('로컬 DB 초기화 오류: $error')),
          ),
        );
      },
    );
  }
}
