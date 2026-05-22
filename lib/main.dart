import 'package:countup/core/db/hive_provider.dart';
import 'package:countup/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 화면 세로 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const ProviderScope(child: CountUpApp()));
}

class CountUpApp extends ConsumerWidget {
  const CountUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbState = ref.watch(hiveBoxProvider);
    const colorScheme = ColorScheme.light(
      primary: Color(0xFF5C6FA3),
      secondary: Color(0xFF5F8F8B),
      surface: Color(0xFFF4F6F8),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1F2937),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CountUp',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: colorScheme.surface,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF5C6FA3),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF5F8F8B),
          foregroundColor: Colors.white,
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
