import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 목표 상세 화면 기록보기 여부 (세션 동안만 유지)
final goalDetailHistoryViewProvider =
    StateProvider.family<bool, String>((ref, goalId) => false);
