import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:littletech/src/features/game/data/models/player_progress.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [PlayerProgressSchema],
    directory: dir.path,
  );
  runApp(LittleTechApp(isar: isar));
}
