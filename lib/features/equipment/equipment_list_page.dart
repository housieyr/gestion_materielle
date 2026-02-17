
import 'dart:io';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../data/db_backup.dart';
import '../../data/tables.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'change_status_dialog.dart';
import 'equipment_form_dialog.dart';
import '../../data/app_database.dart';
import '../../data/daos/equipment_dao.dart';
import 'equipment_grid_source.dart';
import 'equipment_history_dialog.dart';
import '../../data/excel/equipment_excel_importer.dart';

class EquipmentListPage extends StatefulWidget {
  final AppDatabase db;
  const EquipmentListPage({super.key, required this.db});

  @override
  State<EquipmentListPage> createState() => _EquipmentListPageState();
}

class _EquipmentListPageState extends State<EquipmentListPage> {
  List<String> departments = [];
  List<String> types = [];
  List<String> offices = [];

  String? selectedDepartment;
  String? selectedType;
  String? selectedOffice; // اختياري
  EquipmentStatus? selectedStatus;
  late final EquipmentGridSource source;
  final searchCtrl = TextEditingController();
  final DataGridController _gridController = DataGridController();

  @override
  void initState() {
    super.initState();
    source = EquipmentGridSource(db: widget.db);

    Future.microtask(() async {
      await source.loadPage(newPageIndex: 0);
      await refreshLookups();
      if (mounted) setState(() {});
    });
  }

 Future<void>  applyFilters()async {
    source.filter = EquipmentFilter(
      department: selectedDepartment,
      type: selectedType,
      office: selectedOffice, // إذا لا تريده احذف هذا السطر والمتغير
      status: selectedStatus,
      search: searchCtrl.text.trim().isEmpty ? null : searchCtrl.text.trim(),
    );
    await source.loadPage(newPageIndex: 0);
    setState(() {});
  }

  Future<void> clearFilters() async {
    setState(() {
      selectedDepartment = null;
      selectedType = null;
      selectedOffice = null;
      selectedStatus = null;
      searchCtrl.clear();
    });

    await refreshLookups(); // ✅ يرجّع كل القوائم كاملة
    await applyFilters();   // ✅
  }
  Future<void> refreshLookups() async {
    departments = await widget.db.equipmentDao
        .getDistinctDepartmentsFiltered(
      office: selectedOffice,
      type: selectedType,
    );

    types = await widget.db.equipmentDao
        .getDistinctTypesFiltered(
      office: selectedOffice,
      department: selectedDepartment,
    );

    offices = await widget.db.equipmentDao
        .getDistinctOfficesFiltered(
      department: selectedDepartment,
      type: selectedType,
    );

    // ⛑ تصفير القيم غير المتوافقة
    if (selectedDepartment != null &&
        !departments.contains(selectedDepartment)) {
      selectedDepartment = null;
    }

    if (selectedType != null && !types.contains(selectedType)) {
      selectedType = null;
    }

    if (selectedOffice != null && !offices.contains(selectedOffice)) {
      selectedOffice = null;
    }

    if (mounted) setState(() {});
  }bool _filtersOpen = true;
  @override
  Widget build(BuildContext context) {
    final pageCount =
    (source.totalRows / source.rowsPerPage).ceil().clamp(1, 999999);

    return Scaffold(
      appBar: AppBar(
        title: const Text('كل المعدات'),
        actions: [IconButton(
          tooltip: 'الفلاتر',
          icon: Icon(_filtersOpen ? Icons.filter_alt_off : Icons.filter_alt),
          onPressed: () {
            final w = MediaQuery.of(context).size.width;

            // عريض (Desktop/Tablet landscape): افتح Panel جانبي داخل الصفحة
            if (w >= 900) {
              setState(() => _filtersOpen = !_filtersOpen);
              return;
            }

            // ضيق (Tablet portrait): BottomSheet
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => Padding(
                padding: EdgeInsets.only(
                  left: 16, right: 16,
                  top: 16,
                  bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: _FiltersPanel(
                  departments: departments,
                  types: types,
                  offices: offices,
                  selectedDepartment: selectedDepartment,
                  selectedType: selectedType,
                  selectedOffice: selectedOffice,
                  selectedStatus: selectedStatus,
                  searchCtrl: searchCtrl,
                  onChangedDepartment: (v) async { setState(() => selectedDepartment = v); await refreshLookups(); await applyFilters(); },
                  onChangedType: (v) async { setState(() => selectedType = v); await refreshLookups(); await applyFilters(); },
                  onChangedOffice: (v) async { setState(() => selectedOffice = v); await refreshLookups(); await applyFilters(); },
                  onChangedStatus: (v) async { setState(() => selectedStatus = v); await refreshLookups(); await applyFilters(); },
                  onApply: () async { await applyFilters(); if (context.mounted) Navigator.pop(context); },
                  onClear: () async { clearFilters(); if (context.mounted) Navigator.pop(context); },
                ),
              ),
            );
          },
        ),
          IconButton(
            tooltip: 'استيراد من Excel',
            icon: const Icon(Icons.upload_file),
            onPressed: () async {

                final res = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: const ['xlsx'],
                );
                final path = res?.files.single.path;
                if (path == null) return;

                try {
                  // ✅ 1) Backup قبل أي شيء
                  await backupDatabaseFile();

                  // ✅ 2) استيراد (وهو الآن داخل Transaction)
                  final (inserted, skipped) =
                  await EquipmentExcelImporter.importFile(
                    db: widget.db,
                    file: File(path),
                  );

                  await source.loadPage(newPageIndex: 0);
                  await refreshLookups();

                  if (mounted) {
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('تم الاستيراد: $inserted | تم التجاوز: $skipped'),
                      ),
                    );
                  }
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('فشل الاستيراد: $e')),
                  );
                }

            },
          ),
        ],
      ),
      body:  LayoutBuilder(
        builder: (context, c) {
          final wide = c.maxWidth >= 900;

          return Row(
            children: [
              if (wide && _filtersOpen)
                Align(alignment: Alignment.topCenter,
                  child: Card(color: Colors.white,elevation: 5, margin:    EdgeInsets.only(top:2.h,right:1.w   ),
                    child: Container(    padding:   EdgeInsets.all(12),
                      width: 20.w,

                      child: _FiltersPanel(
                        departments: departments,
                        types: types,
                        offices: offices,
                        selectedDepartment: selectedDepartment,
                        selectedType: selectedType,
                        selectedOffice: selectedOffice,
                        selectedStatus: selectedStatus,
                        searchCtrl: searchCtrl,
                        onChangedDepartment: (v) async { setState(() => selectedDepartment = v); await refreshLookups();  await applyFilters(); },
                        onChangedType: (v) async { setState(() => selectedType = v); await refreshLookups();  await applyFilters(); },
                        onChangedOffice: (v) async { setState(() => selectedOffice = v); await refreshLookups();  await applyFilters(); },
                        onChangedStatus: (v) async { setState(() => selectedStatus = v); await refreshLookups();  await applyFilters(); },
                        onApply: applyFilters,
                        onClear: clearFilters,
                      ),
                    ),
                  ),
                ),

              Expanded(
                child: Column(
                  children: [Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                    child: Card(elevation: 5  , color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: OverflowBar(
                          spacing: 8,
                          overflowSpacing: 8,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final res = await showEquipmentFormDialog(context,db: widget.db, isEdit: false);
                                if (res == null) return;

                                await widget.db.equipmentDao.addEquipment(
                                  EquipmentCompanion.insert(
                                    assetCode: res.assetCode,
                                    type: res.type,
                                    model: res.model,
                                    serial: res.serial,
                                    department: res.department,
                                    office: res.office,
                                 status: res.status,
                                    notes: Value(res.notes),
                                  ),
                                );

                                await source.loadPage(newPageIndex: 0);
                                await refreshLookups();
                                if (mounted) setState(() {});
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('إضافة'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final selectedRow = _gridController.selectedIndex;
                                if (selectedRow < 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('اختر صفًا أولاً للتعديل')),
                                  );
                                  return;
                                }
                                final record = source.getByRowIndex(selectedRow);
                                if (record == null) return;

                                final initial = EquipmentFormResult(
                                  assetCode: record.assetCode,
                                  type: record.type,
                                  model: record.model,
                                  serial: record.serial,
                                  department: record.department,
                                  office: record.office,
                                  status: record.status,
                                  notes: record.notes,
                                );

                                final res = await showEquipmentFormDialog(
                                  context,db: widget.db,
                                  initial: initial,
                                  isEdit: true,
                                );
                                if (res == null) return;

                                await widget.db.equipmentDao.updateEquipmentRow(
                                  record.copyWith(
                                    type: res.type,
                                    model: res.model,
                                    serial: res.serial,
                                    department: res.department,
                                    office: res.office,
                                    status: res.status,
                                    notes: Value(res.notes),
                                  ),
                                );

                                await source.loadPage(newPageIndex: source.pageIndex);
                                await refreshLookups();
                                if (mounted) setState(() {});
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('تعديل'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final selectedRow = _gridController.selectedIndex;
                                if (selectedRow < 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('اختر صفًا أولاً')),
                                  );
                                  return;
                                }
                                final record = source.getByRowIndex(selectedRow);
                                if (record == null) return;

                                final res = await showChangeStatusDialog(
                                  context,
                                  current: record.status,
                                );
                                if (res == null) return;

                                await widget.db.equipmentDao.changeStatus(
                                  equipmentId: record.id,
                                  newStatus: res.newStatus,
                                  comment: res.comment,
                                );

                                await source.loadPage(newPageIndex: source.pageIndex);
                                await refreshLookups();
                                if (mounted) setState(() {});
                              },
                              icon: const Icon(Icons.sync_alt),
                              label: const Text('الحالة'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () async {
                                final selectedRow = _gridController.selectedIndex;
                                if (selectedRow < 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('اختر صفًا أولاً')),
                                  );
                                  return;
                                }
                                final record = source.getByRowIndex(selectedRow);
                                if (record == null) return;

                                await showEquipmentHistoryDialog(
                                  context,
                                  db: widget.db,
                                  equipment: record,
                                );
                              },
                              icon: const Icon(Icons.history),
                              label: const Text('السجل'),
                            ),

                            const SizedBox(width: 16),

                            // عدد الصفوف
                            DropdownButton<int>(
                              value: source.rowsPerPage,
                              items: const [10, 25, 50, 100]
                                  .map((e) => DropdownMenuItem(value: e, child: Text('الصفوف: $e')))
                                  .toList(),
                              onChanged: (v) {
                                if (v == null) return;
                                setState(() => source.rowsPerPage = v);
                                source.loadPage(newPageIndex: 0);
                              },
                            ),

                            OutlinedButton(
                              onPressed: clearFilters,
                              child: const Text('مسح الفلاتر'),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Text('الإجمالي: ${source.totalRows}'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    // (هنا نحط Toolbar صغير فوق الجدول في الخطوة 2.2)
                    Expanded(
                      child: Padding(

                        padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 3.h),
                        child: SfDataGrid(columnWidthMode: ColumnWidthMode.fill,

                          gridLinesVisibility: GridLinesVisibility.both, // الصفوف + الأعمدة
                          headerGridLinesVisibility: GridLinesVisibility.both,


                          source: source,
                          allowSorting: true,
                          controller: _gridController,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.row,
                          onColumnSortChanged: (newSorted, oldSorted) {
                            if (newSorted == null) {
                              source.sortColumn = 'id';
                              source.sortAsc = false;
                            } else {
                              source.sortColumn = newSorted.name;
                              source.sortAsc = newSorted.sortDirection == DataGridSortDirection.ascending;
                            }
                            source.loadPage(newPageIndex: 0);
                            setState(() {});
                          },
                          columns: [
                            GridColumn(columnName: 'assetCode', label: _h('AssetCode')),
                            GridColumn(columnName: 'type', label: _h('النوع')),
                            GridColumn(columnName: 'model', label: _h('الموديل')),
                            GridColumn(columnName: 'serial', label: _h('Serial')),
                            GridColumn(columnName: 'department', label: _h('الإدارة')),
                            GridColumn(columnName: 'office', label: _h('المكتب')),
                            GridColumn(columnName: 'status', label: _h('الحالة')),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SfDataPager(
                        delegate: source,
                        pageCount: ((source.totalRows / source.rowsPerPage).ceil().clamp(1, 999999)).toDouble(),
                        direction: Axis.horizontal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _h(String text) {
    return Container(
      alignment: Alignment.center, // 🔥 CENTER HEADER
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class _FiltersPanel extends StatelessWidget {
  final List<String> departments;
  final List<String> types;
  final List<String> offices;

  final String? selectedDepartment;
  final String? selectedType;
  final String? selectedOffice;
  final EquipmentStatus? selectedStatus;

  final TextEditingController searchCtrl;

  final Future<void> Function(String?) onChangedDepartment;
  final Future<void> Function(String?) onChangedType;
  final Future<void> Function(String?) onChangedOffice;
  final Future<void> Function(EquipmentStatus?) onChangedStatus;

  final Future<void> Function() onApply;
  final Future<void> Function() onClear;

  const _FiltersPanel({
    required this.departments,
    required this.types,
    required this.offices,
    required this.selectedDepartment,
    required this.selectedType,
    required this.selectedOffice,
    required this.selectedStatus,
    required this.searchCtrl,
    required this.onChangedDepartment,
    required this.onChangedType,
    required this.onChangedOffice,
    required this.onChangedStatus,
    required this.onApply,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label) => InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
      isDense: true,
    );

    Widget ddString({
      required String label,
      required String? value,
      required List<String> items,
      required Future<void> Function(String?) onChanged,
    }) {
      return DropdownButtonFormField<String?>(
        isExpanded: true,
        value: value,
        decoration: deco(label),
        items: [
          const DropdownMenuItem<String?>(value: null, child: Text('الكل')),
          ...items.map((x) => DropdownMenuItem(
            value: x,
            child: Text(x, maxLines: 1, overflow: TextOverflow.ellipsis),
          )),
        ],
        onChanged: (v) async => await onChanged(v),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: searchCtrl,
          decoration: deco('بحث (Asset/Serial/Model)'),
          onSubmitted: (_) => onApply(),
        ),
        const SizedBox(height: 12),
        ddString(label: 'الإدارة', value: selectedDepartment, items: departments, onChanged: onChangedDepartment),
        const SizedBox(height: 12),
        ddString(label: 'النوع', value: selectedType, items: types, onChanged: onChangedType),
        const SizedBox(height: 12),
        ddString(label: 'المكتب', value: selectedOffice, items: offices, onChanged: onChangedOffice),
        const SizedBox(height: 12),

        DropdownButtonFormField<EquipmentStatus?>(
          isExpanded: true,
          value: selectedStatus,
          decoration: deco('الحالة'),
          items: const [
            DropdownMenuItem(value: null, child: Text('الكل')),
            DropdownMenuItem(value: EquipmentStatus.working, child: Text('✅ تعمل')),
            DropdownMenuItem(value: EquipmentStatus.needsMaintenance, child: Text('⚠️ تحتاج صيانة')),
            DropdownMenuItem(value: EquipmentStatus.inRepair, child: Text('🛠️ في التصليح')),
            DropdownMenuItem(value: EquipmentStatus.outOfService, child: Text('❌ خارج الخدمة')),
          ],
          onChanged: (v) => onChangedStatus(v),
        ),

        const SizedBox(height: 16),
        Row(
          children: [
           Expanded(
  child: Container(
    height:5.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(45),
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF6A8DFF), // اللون العلوي
          Color(0xFF3F55C6), // اللون السفلي
        ],
      ),
    ),
    child: ElevatedButton(
      onPressed: () => onApply(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(45),
        ),
      ),
      child: const Text(
        'تطبيق',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    ),
  ),
),
            const SizedBox(width: 12),
            Expanded(
            child: SizedBox(
    height: 5.h,
                child: OutlinedButton(    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                  onPressed: () => onClear(),
                  child: const Text('مسح' , style: TextStyle(
                          fontWeight: FontWeight.w600,

                        ),),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}