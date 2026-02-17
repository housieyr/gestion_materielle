import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';

import '../app_database.dart';
import '../tables.dart';

/// Excel importer compatible with the Drift schema.
///
/// Expected headers (Arabic, as used in many internal templates):
/// - ع/ر
/// - نوع العتاد
/// - المصنع
/// - الرقم التسلسلي
/// - الهيكل
/// - المكتب
/// - الملاحظات  (we treat it as "الحالة" if it matches known statuses)
class EquipmentExcelImporter {
  static Future<(int inserted, int skipped)> importFile({
    required AppDatabase db,
    required File file,
  }) async {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    if (excel.tables.isEmpty) {
      throw Exception('الملف لا يحتوي على Sheets.');
    }

    final sheet = excel.tables.values.first;
    if (sheet == null || sheet.rows.isEmpty) {
      throw Exception('الـSheet فارغ.');
    }

    final headerRow = sheet.rows.first;
    final headers = headerRow
        .map((c) => (c?.value?.toString() ?? '').trim())
        .toList(growable: false);

    int idxOf(String name) => headers.indexWhere((h) => h == name);

    final idxAsset = idxOf('ع/ر');
    final idxType = idxOf('نوع العتاد');
    final idxModel = idxOf('المصنع');
    final idxSerial = idxOf('الرقم التسلسلي');
    final idxDept = idxOf('الهيكل');
    final idxOffice = idxOf('المكتب');
    final idxNotesOrStatus = idxOf('الملاحظات');

    final required = {
      'ع/ر': idxAsset,
      'نوع العتاد': idxType,
      'المصنع': idxModel,
      'الرقم التسلسلي': idxSerial,
      'الهيكل': idxDept,
      'المكتب': idxOffice,
      'الملاحظات': idxNotesOrStatus,
    };

    final missing = required.entries
        .where((e) => e.value < 0)
        .map((e) => e.key)
        .toList(growable: false);
    if (missing.isNotEmpty) {
      throw Exception('أعمدة ناقصة في Excel: ${missing.join(', ')}');
    }

    String cellStr(List<Data?> row, int i) {
      if (i < 0 || i >= row.length) return '';
      return (row[i]?.value?.toString() ?? '').trim();
    }

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
    int inserted = 0;
    int skipped = 0;

    // We rely on the UNIQUE constraint (assetCode) to skip duplicates.
    await db.transaction(() async {
      for (int r = 1; r < sheet.rows.length; r++) {
        final row = sheet.rows[r];

        final assetCode = cellStr(row, idxAsset);
        final type = cellStr(row, idxType);
        final model = cellStr(row, idxModel);
        final serial = cellStr(row, idxSerial);
        final department = cellStr(row, idxDept);
        final office = cellStr(row, idxOffice);
        final notesOrStatus = cellStr(row, idxNotesOrStatus);

        if (assetCode.isEmpty ||
            type.isEmpty ||
            department.isEmpty ||
            office.isEmpty) {
          skipped++;
          continue;
        }

        final status = _parseStatus(notesOrStatus) ?? EquipmentStatus.working;
        final notes = _parseStatus(notesOrStatus) == null && notesOrStatus.isNotEmpty
            ? notesOrStatus
            : null;
        await db.transaction(() async {

        try {
          await db.equipmentDao.addEquipment(
            EquipmentCompanion.insert(
              assetCode: assetCode,
              type: type,
              model: model,
              serial: serial,
              department: department,
              office: office,
              status: status,
              notes: Value(notes),
            ),
          );
          inserted++;
        } catch (_) {
          // Likely duplicate key or validation issue.
          skipped++;
        }
      }    );
    }});

    return (inserted, skipped);
  }
}

EquipmentStatus? _parseStatus(String raw) {
  final s = raw.trim();
  if (s.isEmpty) return null;

  // Normalize a bit.
  final lower = s.toLowerCase();

  bool hasAny(List<String> needles) => needles.any((n) => lower.contains(n));

  if (hasAny(['تعمل', 'working', 'ok', '✅'])) return EquipmentStatus.working;
  if (hasAny(['تحتاج صيانة', 'صيانة', 'maintenance', '⚠'])) {
    return EquipmentStatus.needsMaintenance;
  }
  if (hasAny(['في التصليح', 'تصليح', 'repair', '🛠'])) return EquipmentStatus.inRepair;
  if (hasAny(['خارج الخدمة', 'out of service', '❌', 'معطل', 'متعطل'])) {
    return EquipmentStatus.outOfService;
  }

  return null;
}
