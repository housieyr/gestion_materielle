import 'package:flutter/material.dart';

import 'app/app.dart';
import 'data/app_database.dart';

import 'dart:io';
import 'package:window_manager/window_manager.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();

    await windowManager.waitUntilReadyToShow(
      const WindowOptions(
        center: true,
        title: 'Gestion Matériel',
        minimumSize: Size(1280, 720), // اختياري لكن مُستحسن
      ),
          () async {
        await windowManager.show();
        await windowManager.maximize(); // ✅ هذا هو المهم
        await windowManager.focus();
      },
    );
  }

  final db = AppDatabase();
  runApp(App(db: db));
}
