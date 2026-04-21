import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

const goalsBoxName = 'goals_box';

final hiveBoxProvider = FutureProvider<Box<Map>>((ref) async {
  await Hive.initFlutter();
  return Hive.openBox<Map>(goalsBoxName);
});
