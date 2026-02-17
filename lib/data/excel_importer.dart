import 'dart:io';
import 'package:excel/excel.dart';
import 'package:sqflite/sqflite.dart';
import 'app_db.dart';
import 'equipment.dart';

class ExcelImporter {
  /// يستورد ملف Excel (xlsx) إلى SQLite
  /// يرجع: (inserted, skipped)
  static Future<(int inserted, int skipped)> importEquipment(File file) async {
    final bytes = file.readAsBytesSync();
    final excel = Excel.decodeBytes(bytes);

    if (excel.tables.isEmpty) {
      throw Exception('الملف لا يحتوي على Sheets.');
    }

    // نأخذ أول Sheet (تقدر تغيّره لاحقًا لاختيار sheet)
    final sheet = excel.tables.values.first;
    if (sheet == null || sheet.rows.isEmpty) {
      throw Exception('الـSheet فارغ.');
    }

    // --- 1) قراءة الهيدر (الصف الأول) وتحديد فهارس الأعمدة حسب العنوان ---
    final headerRow = sheet.rows.first;
    final headers = headerRow
        .map((c) => (c?.value?.toString() ?? '').trim())
        .toList();

    int idxOf(String name) => headers.indexWhere((h) => h == name);

    final idxInv = idxOf('ع/ر'); // رقم العدة
    final idxType = idxOf('نوع العتاد');
    final idxManu = idxOf('المصنع');
    final idxSerial = idxOf('الرقم التسلسلي');
    final idxDept = idxOf('الهيكل');
    final idxOffice = idxOf('المكتب');
    final idxStatus = idxOf('الملاحظات'); // تعمل/تحتاج صيانة/...

    // تحقق سريع
    final required = {
      'ع/ر': idxInv,
      'نوع العتاد': idxType,
      'المصنع': idxManu,
      'الرقم التسلسلي': idxSerial,
      'الهيكل': idxDept,
      'المكتب': idxOffice,
      'الملاحظات': idxStatus,
    };

    final missing = required.entries.where((e) => e.value < 0).map((e) => e.key).toList();
    if (missing.isNotEmpty) {
      throw Exception('أعمدة ناقصة في Excel: ${missing.join(', ')}');
    }

    // --- 2) إدخال الصفوف ---
    int inserted = 0;
    int skipped = 0;

    final database = await AppDb.instance.db;

    await database.transaction((txn) async {
      for (int r = 1; r < sheet.rows.length; r++) {
        final row = sheet.rows[r];

        String cellStr(int i) => (row[i]?.value?.toString() ?? '').trim();

        final invStr = cellStr(idxInv);
        final inv = int.tryParse(invStr);
        final type = cellStr(idxType);
        final manu = cellStr(idxManu);
        final serial = cellStr(idxSerial);
        final dept = cellStr(idxDept);
        final office = cellStr(idxOffice);
        final status = cellStr(idxStatus);

        // تجاهل الصفوف الفارغة/غير الصالحة
        if (inv == null || type.isEmpty || manu.isEmpty || serial.isEmpty || dept.isEmpty || office.isEmpty || status.isEmpty) {
          skipped++;
          continue;
        }

        final item = Equipment(
          inventoryNumber: inv,
          type: type,
          manufacturer: manu,
          serialNumber: serial,
          department: dept,
          office: office,
          status: status,
          notes: null,
        );

        final id = await txn.insert(
          'equipment',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );

        if (id == 0) {
          // غالبًا serial مكرر (UNIQUE)
          skipped++;
        } else {
          inserted++;
        }
      }
    });

    return (inserted, skipped);
  }
}
