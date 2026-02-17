import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/app_database.dart';
import '../../data/tables.dart';
import '../../data/daos/equipment_dao.dart';

class EquipmentGridSource extends DataGridSource {
  final AppDatabase db;

  EquipmentGridSource({required this.db});

  List<EquipmentData> _data = [];
  List<DataGridRow> _rows = [];

  EquipmentFilter filter = const EquipmentFilter();

  int rowsPerPage = 10;
  int pageIndex = 0;

  String sortColumn = 'id';
  bool sortAsc = false;

  int totalRows = 0;

  // تحميل صفحة معيّنة من DB
  Future<void> loadPage({required int newPageIndex}) async {
    pageIndex = newPageIndex;

    totalRows = await db.equipmentDao.countEquipment(filter);

    final page = await db.equipmentDao.fetchEquipmentPage(
      filter: filter,
      pageIndex: pageIndex,
      pageSize: rowsPerPage,
      sortColumn: sortColumn,
      sortAsc: sortAsc,
    );

    _data = page;
    _rows = _data.map((e) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'assetCode', value: e.assetCode),
        DataGridCell<String>(columnName: 'type', value: e.type),
        DataGridCell<String>(columnName: 'model', value: e.model),
        DataGridCell<String>(columnName: 'serial', value: e.serial),
        DataGridCell<String>(columnName: 'department', value: e.department),
        DataGridCell<String>(columnName: 'office', value: e.office),
        DataGridCell<EquipmentStatus>(columnName: 'status', value:  e.status) ,
      ]);
    }).toList();
    notifyListeners();
    notifyDataSourceListeners();
    notifyListeners();
  }

  String _statusText(EquipmentStatus s) {
    switch (s) {
      case EquipmentStatus.working:
        return '✅ تعمل';
      case EquipmentStatus.needsMaintenance:
        return '⚠️ تحتاج صيانة';
      case EquipmentStatus.inRepair:
        return '🛠️ في التصليح';
      case EquipmentStatus.outOfService:
        return '❌ خارج الخدمة';
    }
  }
  EquipmentData? getByRowIndex(int rowIndex) {
    if (rowIndex < 0 || rowIndex >= _data.length) return null;
    return _data[rowIndex];
  }
  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {final index = effectiveRows.indexOf(row);
    final cells = row.getCells().map((cell) {
      if (cell.columnName == 'status') {
        final s = cell.value as EquipmentStatus;

        late final Color color;
        late final IconData icon;
        late final String label;

        switch (s) {
          case EquipmentStatus.working:
            color = const Color(0xFF2E7D32); // أخضر داكن
            icon = Icons.check_circle;
            label = 'تعمل';
            break;

          case EquipmentStatus.needsMaintenance:
            color = const Color(0xFFED6C02); // برتقالي
            icon = Icons.warning_amber_rounded;
            label = 'تحتاج صيانة';
            break;

          case EquipmentStatus.inRepair:
            color = const Color(0xFF1565C0); // أزرق
            icon = Icons.build_circle;
            label = 'في التصليح';
            break;

          case EquipmentStatus.outOfService:
            color = const Color(0xFFC62828); // أحمر
            icon = Icons.block;
            label = 'خارج الخدمة';
            break;
        }

        return Align(
          alignment: Alignment.center ,
          child: Chip(
            backgroundColor: color.withOpacity(0.12),
            avatar: Icon(icon, color: color, size: 18),
            label: Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        );
      }
      return Container(
        alignment: Alignment.center ,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          '${cell.value ?? ''}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }).toList();

    return DataGridRowAdapter( color: index.isEven
        ? Colors.blue.shade100 // صف أساسي
        : Colors.blue.shade200.withOpacity(0.35),cells: cells);  // صف أفتح,  cells: cells);
  }

  // مهم: هذا الذي يستدعيه SfDataPager عند تغيير الصفحة :contentReference[oaicite:2]{index=2}
  @override
  Future<bool> handlePageChange(int oldPageIndex, int newPageIndex) async {
    await loadPage(newPageIndex: newPageIndex);
    return true;
  }
}
