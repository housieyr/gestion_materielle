import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<File> backupDatabaseFile() async {
  final dir = await getApplicationSupportDirectory();

  // ⚠️ نفس اسم ملف DB الموجود في app_database.dart
  final dbFile = File('${dir.path}/media_stock.sqlite');

  if (!await dbFile.exists()) {
    throw Exception('قاعدة البيانات غير موجودة');
  }

  final timestamp = DateTime.now()
      .toIso8601String()
      .replaceAll(':', '-')
      .replaceAll('.', '-');

  final backupFile =
  File('${dir.path}/backup_media_stock_$timestamp.sqlite');

  return dbFile.copy(backupFile.path);
}