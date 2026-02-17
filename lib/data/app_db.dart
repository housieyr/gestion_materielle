import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'equipment.dart';

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();
  Future<Map<String, Object?>> getEquipmentMini(int id) async {
    final database = await db;
    final res = await database.query(
      'equipment',
      columns: ['status', 'office', 'department', 'notes'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (res.isEmpty) throw Exception('المعدة غير موجودة');
    return res.first;
  }

  void _validateBusinessRules({
    required Map<String, Object?> current,
    required String field,
    required Object? newValue,
  }) {
    final curStatus = (current['status'] ?? '').toString();
    final curNotes = (current['notes'] ?? '').toString();

    // ✅ القاعدة 1: إذا كانت خارج الخدمة → ممنوع تغيير المكتب أو الهيكل
    if (curStatus == 'خارج الخدمة' &&
        (field == 'office' || field == 'department')) {
      throw BusinessRuleException(
        'لا يمكن تغيير المكتب/الهيكل لمعدة خارج الخدمة.',
      );
    }

    // ✅ القاعدة 2: عند وضع "في التصليح" لازم يكون عندها ملاحظة (سبب/تذكرة)
    if (field == 'status' && newValue?.toString() == 'في التصليح') {
      if (curNotes.trim().isEmpty) {
        throw BusinessRuleException(
          'قبل تحويلها إلى "في التصليح"، اكتب سبب/تذكرة في الملاحظات.',
        );
      }
    }

    // ✅ القاعدة 3 (اختيارية مفيدة): Serial لا يسمح بفارغ
    if (field == 'serialNumber' &&
        (newValue?.toString().trim().isEmpty ?? true)) {
      throw BusinessRuleException('الرقم التسلسلي لا يمكن أن يكون فارغًا.');
    }
  }

  Database? _db;
  Future<List<Map<String, Object?>>> getAuditForEquipment(
    int equipmentId,
  ) async {
    final database = await db;
    return database.query(
      'audit_log',
      where: 'equipmentId = ?',
      whereArgs: [equipmentId],
      orderBy: 'id DESC',
      limit: 200,
    );
  }

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'media_inventory_v5.db');
    print('DB PATH: $path');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE equipment(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
           inventoryNumber INTEGER NOT NULL,
            type TEXT NOT NULL,
            manufacturer TEXT NOT NULL,
            serialNumber TEXT NOT NULL UNIQUE,
            department TEXT NOT NULL,
            office TEXT NOT NULL,
            status TEXT NOT NULL,
            notes TEXT
          );
        ''');
        await database.execute('''
CREATE TABLE audit_log (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  equipmentId INTEGER NOT NULL,
  action TEXT NOT NULL,          -- e.g. "UPDATE_FIELD", "INSERT"
  field TEXT,                    -- اسم الحقل الذي تغير (قد يكون null عند INSERT)
  oldValue TEXT,
  newValue TEXT,
  at TEXT NOT NULL               -- ISO datetime
);
''');
      },
    );

    return _db!;
  }

  Future<void> addAudit({
    required int equipmentId,
    required String action,
    String? field,
    String? oldValue,
    String? newValue,
  }) async {
    final database = await db;
    await database.insert('audit_log', {
      'equipmentId': equipmentId,
      'action': action,
      'field': field,
      'oldValue': oldValue,
      'newValue': newValue,
      'at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> insertEquipment(Equipment e) async {
    final database = await db;
    return database.insert(
      'equipment',
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<int> updateFieldLogged({
    required int id,
    required String field,
    required Object? value,
  }) async {
    final database = await db;

    // 1) نجيب القيمة القديمة
    final oldRes = await database.query(
      'equipment',
      columns: [field],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    final oldVal = oldRes.isEmpty ? null : oldRes.first[field]?.toString();
    final current = await getEquipmentMini(id);
    _validateBusinessRules(current: current, field: field, newValue: value);
    // 2) نحدّث
    final updated = await database.update(
      'equipment',
      {field: value},
      where: 'id = ?',
      whereArgs: [id],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );

    // 3) نسجّل في السجل فقط إذا تم التحديث وفعلاً تغيّر شيء
    final newVal = value?.toString();
    if (updated > 0 && oldVal != newVal) {
      await addAudit(
        equipmentId: id,
        action: 'UPDATE_FIELD',
        field: field,
        oldValue: oldVal,
        newValue: newVal,
      );
    }

    return updated;
  }

  Future<List<Equipment>> getFilteredEquipment({
    required String smartQuery,
    required String type,
    required String department,
    required String office,
    required String status,
  }) async {
    final database = await db;

    final where = <String>[];
    final args = <Object?>[];

    if (smartQuery.trim().isNotEmpty) {
      final q = smartQuery.trim();

      final asInt = int.tryParse(q);
      if (asInt != null) {
        // إذا كتب رقم: نبحث في رقم العدة + وأيضًا كنص
        where.add(
          '('
          'inventoryNumber = ? OR '
          'serialNumber LIKE ? OR '
          'manufacturer LIKE ? OR '
          'type LIKE ? OR '
          'department LIKE ? OR '
          'office LIKE ? OR '
          'notes LIKE ? OR '
          'status LIKE ?'
          ')',
        );
        args.add(asInt);
        for (int i = 0; i < 7; i++) {
          args.add('%$q%');
        }
      } else {
        where.add(
          '('
          'serialNumber LIKE ? OR '
          'manufacturer LIKE ? OR '
          'type LIKE ? OR '
          'department LIKE ? OR '
          'office LIKE ? OR '
          'notes LIKE ? OR '
          'status LIKE ?'
          ')',
        );
        for (int i = 0; i < 7; i++) {
          args.add('%$q%');
        }
      }
    }

    if (type != 'الكل') {
      where.add('type = ?');
      args.add(type);
    }
    if (department != 'الكل') {
      where.add('department = ?');
      args.add(department);
    }
    if (office != 'الكل') {
      where.add('office = ?');
      args.add(office);
    }
    if (status != 'الكل') {
      where.add('status = ?');
      args.add(status);
    }

    final rows = await database.query(
      'equipment',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'id DESC',
    );

    return rows.map(Equipment.fromMap).toList();
  }

  /// ✅ قيم الفلاتر من قاعدة البيانات (بدون تكرار)
  Future<List<String>> getDistinct(String column) async {
    // column من داخل التطبيق فقط (آمن)
    final database = await db;
    final rows = await database.rawQuery(
      'SELECT DISTINCT $column FROM equipment ORDER BY $column ASC',
    );
    final values = rows
        .map((r) => (r[column] ?? '').toString())
        .where((v) => v.trim().isNotEmpty)
        .toList();
    return ['الكل', ...values];
  }

  Future<Map<String, List<String>>> getAllDistinctFilters() async {
    final types = await getDistinct('type');
    final depts = await getDistinct('department');
    final offices = await getDistinct('office');
    final statuses = await getDistinct('status');
    return {
      'type': types,
      'department': depts,
      'office': offices,
      'status': statuses,
    };
  }

  Future<int> getNextInventoryNumber() async {
    final database = await db;
    final res = await database.rawQuery(
      'SELECT MAX(inventoryNumber) AS m FROM equipment',
    );
    final maxVal = res.first['m'];
    final maxNum = (maxVal is int) ? maxVal : int.tryParse('$maxVal') ?? 0;
    return maxNum + 1;
  }

  Future<bool> serialExists(String serial) async {
    final database = await db;
    final res = await database.query(
      'equipment',
      columns: ['id'],
      where: 'serialNumber = ?',
      whereArgs: [serial.trim()],
      limit: 1,
    );
    return res.isNotEmpty;
  }

  Future<int> insertEquipmentIgnoreDuplicateSerial(Equipment e) async {
    final database = await db;
    return database.insert(
      'equipment',
      e.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore, // ✅ يتجاهل المكرر
    );
  }

  Future<int> countFilteredEquipment({
    required String smartQuery,
    required String type,
    required String department,
    required String office,
    required String status,
  }) async {
    final database = await db;

    final where = <String>[];
    final args = <Object?>[];

    if (smartQuery.trim().isNotEmpty) {
      where.add('serialNumber LIKE ?');
      args.add('%${smartQuery.trim()}%');
    }
    if (type != 'الكل') {
      where.add('type = ?');
      args.add(type);
    }
    if (department != 'الكل') {
      where.add('department = ?');
      args.add(department);
    }
    if (office != 'الكل') {
      where.add('office = ?');
      args.add(office);
    }
    if (status != 'الكل') {
      where.add('status = ?');
      args.add(status);
    }

    final res = await database.rawQuery('''
    SELECT COUNT(*) as c
    FROM equipment
    ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
    ''', args);

    final v = res.first['c'];
    return (v is int) ? v : int.tryParse('$v') ?? 0;
  }

  Future<Map<String, int>> countByStatus() async {
    final database = await db;

    final rows = await database.rawQuery('''
    SELECT status, COUNT(*) as c
    FROM equipment
    GROUP BY status
  ''');

    final map = <String, int>{};
    for (final r in rows) {
      map[r['status'].toString()] = (r['c'] as int);
    }
    return map;
  }

  Future<List<String>> getDistinctFiltered({
    required String column, // type/department/office/status
    required String smartQuery,
    required String type,
    required String department,
    required String office,
    required String status,
    String? ignoreColumn, // نخلي نفس العمود لا يقيّد نفسه
  }) async {
    final database = await db;

    final where = <String>[];
    final args = <Object?>[];

    // serial يطبّق على الجميع
    if (smartQuery.trim().isNotEmpty) {
      where.add('serialNumber LIKE ?');
      args.add('%${smartQuery.trim()}%');
    }

    void addFilter(String colName, String val) {
      if (val == 'الكل') return;
      if (ignoreColumn == colName) return;
      where.add('$colName = ?');
      args.add(val);
    }

    addFilter('type', type);
    addFilter('department', department);
    addFilter('office', office);
    addFilter('status', status);

    final rows = await database.rawQuery('''
    SELECT DISTINCT $column AS v
    FROM equipment
    ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
    ORDER BY v ASC
    ''', args);

    final values = rows
        .map((r) => (r['v'] ?? '').toString().trim())
        .where((v) => v.isNotEmpty)
        .toList();
    final uniq = values.map((e) => e.trim()).where((e) => e.isNotEmpty).toSet().toList();
    return ['الكل', ...uniq];

  }

  Future<List<Equipment>> getFilteredEquipmentPaged({
    required String smartQuery,
    required String type,
    required String department,
    required String office,
    required String status,
    required int limit,
    required int offset,
  }) async {
    final database = await db;

    final where = <String>[];
    final args = <Object?>[];

    if (smartQuery.trim().isNotEmpty) {
      final q = smartQuery.trim();

      final asInt = int.tryParse(q);
      if (asInt != null) {
        // إذا كتب رقم: نبحث في رقم العدة + وأيضًا كنص
        where.add(
          '('
          'inventoryNumber = ? OR '
          'serialNumber LIKE ? OR '
          'manufacturer LIKE ? OR '
          'type LIKE ? OR '
          'department LIKE ? OR '
          'office LIKE ? OR '
          'notes LIKE ? OR '
          'status LIKE ?'
          ')',
        );
        args.add(asInt);
        for (int i = 0; i < 7; i++) {
          args.add('%$q%');
        }
      } else {
        where.add(
          '('
          'serialNumber LIKE ? OR '
          'manufacturer LIKE ? OR '
          'type LIKE ? OR '
          'department LIKE ? OR '
          'office LIKE ? OR '
          'notes LIKE ? OR '
          'status LIKE ?'
          ')',
        );
        for (int i = 0; i < 7; i++) {
          args.add('%$q%');
        }
      }
    }
    if (type != 'الكل') {
      where.add('type = ?');
      args.add(type);
    }
    if (department != 'الكل') {
      where.add('department = ?');
      args.add(department);
    }
    if (office != 'الكل') {
      where.add('office = ?');
      args.add(office);
    }
    if (status != 'الكل') {
      where.add('status = ?');
      args.add(status);
    }

    final rows = await database.query(
      'equipment',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args.isEmpty ? null : args,
      orderBy: 'id DESC',
      limit: limit,
      offset: offset,
    );

    return rows.map(Equipment.fromMap).toList();
  }
}

class BusinessRuleException implements Exception {
  final String message;
  BusinessRuleException(this.message);

  @override
  String toString() => message;
}
