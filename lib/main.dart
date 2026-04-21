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
    return MaterialApp.router(
      title: 'CountUp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
