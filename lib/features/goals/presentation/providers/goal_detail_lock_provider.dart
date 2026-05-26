import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 목표 상세 화면 잠금 여부 (세션 동안만 유지)
final goalDetailLockedProvider =
    StateProvider.family<bool, String>((ref, goalId) => false);
