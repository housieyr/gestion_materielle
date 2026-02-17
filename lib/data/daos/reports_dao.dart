import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables.dart';

part 'reports_dao.g.dart';

// نتيجة تقرير مخزون الإدارة
class DepartmentStockRow {
  final String department;
  final int total;
  final int available; // working
  final int needsMaintenance;
  final int inRepair;
  final int outOfService;

  DepartmentStockRow({
    required this.department,
    required this.total,
    required this.available,
    required this.needsMaintenance,
    required this.inRepair,
    required this.outOfService,
  });
}

@DriftAccessor(tables: [Equipment, EquipmentHistory])
class ReportsDao extends DatabaseAccessor<AppDatabase> with _$ReportsDaoMixin {
  ReportsDao(super.db);

  // ====== تقرير: مخزون كل إدارة + عدد المتاح ======
  Stream<List<DepartmentStockRow>> watchDepartmentStock() {
    // نستخدم CustomSelect لتجميع شروط متعددة
    final sql = '''
      SELECT 
        department AS department,
        COUNT(*) AS total,
        SUM(CASE WHEN status = ${EquipmentStatus.working.index} THEN 1 ELSE 0 END) AS available,
        SUM(CASE WHEN status = ${EquipmentStatus.needsMaintenance.index} THEN 1 ELSE 0 END) AS needsMaintenance,
        SUM(CASE WHEN status = ${EquipmentStatus.inRepair.index} THEN 1 ELSE 0 END) AS inRepair,
        SUM(CASE WHEN status = ${EquipmentStatus.outOfService.index} THEN 1 ELSE 0 END) AS outOfService
      FROM equipment
      GROUP BY department
      ORDER BY department ASC
    ''';

    return customSelect(sql, readsFrom: {equipment}).watch().map((rows) {
      return rows.map((r) {
        return DepartmentStockRow(
          department: r.read<String>('department'),
          total: r.read<int>('total'),
          available: r.read<int>('available'),
          needsMaintenance: r.read<int>('needsMaintenance'),
          inRepair: r.read<int>('inRepair'),
          outOfService: r.read<int>('outOfService'),
        );
      }).toList();
    });
  }

  // ====== تقرير: معدات متكررة الأعطال ======
  // التعريف: عدد مرات الانتقال إلى needsMaintenance أو inRepair خلال فترة معينة >= threshold
  Stream<List<EquipmentData>> watchFrequentlyFaulty({
    required int daysBack,     // مثال 180
    required int threshold,    // مثال 3
  }) {
    final since = DateTime.now().subtract(Duration(days: daysBack));

    final sql = '''
      SELECT e.*
      FROM equipment e
      JOIN (
        SELECT equipment_id, COUNT(*) AS cnt
        FROM equipment_history
        WHERE changed_at >= ?
          AND new_status IN (${EquipmentStatus.needsMaintenance.index}, ${EquipmentStatus.inRepair.index})
        GROUP BY equipment_id
        HAVING COUNT(*) >= ?
      ) x ON x.equipment_id = e.id
      ORDER BY x.cnt DESC
    ''';

    return customSelect(
      sql,
      variables: [Variable<DateTime>(since), Variable<int>(threshold)],
      readsFrom: {equipment, equipmentHistory},
    ).watch().map((rows) {
      // تحويل row -> EquipmentData باستخدام Generated mapper
      return rows.map((r) => EquipmentData(
        id: r.read<int>('id'),
        assetCode: r.read<String>('asset_code'),
        type: r.read<String>('type'),
        model: r.read<String>('model'),
        serial: r.read<String>('serial'),
        department: r.read<String>('department'),
        office: r.read<String>('office'),
        status: EquipmentStatus.values[r.read<int>('status')],
        notes: r.readNullable<String>('notes'),
        createdAt: r.read<DateTime>('created_at'),
      )).toList();
    });
  }
}
