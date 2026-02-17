import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';
import 'daos/equipment_dao.dart';
import 'daos/reports_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Equipment, EquipmentHistory],
  daos: [EquipmentDao, ReportsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  // رفعنا النسخة لمعالجة قيم تاريخ/وقت تالفة كانت تُحفظ كنص SQL بدل رقم.
  // هذا يمنع crash عند قراءة DateTime عبر Drift.
  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // إصلاح بيانات قديمة (أو مُهاجرة) حيث تم تخزين الـ default expression كنص حرفيًا.
          // Drift يخزّن DateTime كـ INTEGER (Unix seconds) افتراضيًا على SQLite.
          if (from < 2) {
            // equipment.created_at
            await customStatement('''
              UPDATE equipment
              SET created_at = CAST(strftime('%s','now') AS INTEGER)
              WHERE created_at IS NULL
                 OR (typeof(created_at) = 'text' AND created_at LIKE '%strftime(%')
            ''');

            // equipment_history.changed_at
            await customStatement('''
              UPDATE equipment_history
              SET changed_at = CAST(strftime('%s','now') AS INTEGER)
              WHERE changed_at IS NULL
                 OR (typeof(changed_at) = 'text' AND changed_at LIKE '%strftime(%')
            ''');
          }
        },
      );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationSupportDirectory();
    final dbFile = File(p.join(dir.path, 'media_stock.sqlite'));
    print(dbFile);
    return NativeDatabase.createInBackground(dbFile);
  });
}
