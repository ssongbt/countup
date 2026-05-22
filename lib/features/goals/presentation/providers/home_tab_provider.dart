import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 0: 진행 중, 1: 완료
final homeTabIndexProvider = StateProvider<int>((ref) => 0);
