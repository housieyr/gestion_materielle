import 'dart:async';
import 'package:flutter/cupertino.dart';

import '../data/app_db.dart';
import '../data/equipment.dart';

class EquipmentController {
  final _items = <Equipment>[];
  List<Equipment> get items => List.unmodifiable(_items);
  Map<String, int> statusCounts = {};
  // الفلاتر
  String smartQ = '';
  String type = 'الكل';
  String department = 'الكل';
  String office = 'الكل';
  String status = 'الكل';
  int pageSize = 10;
  int page = 0; // 0-based
  int totalCount = 0;
  int get totalPages => totalCount == 0 ? 1 : ((totalCount - 1) ~/ pageSize) + 1;
  // قوائم الدروبداون (من DB)
  List<String> typeOptions = const ['الكل'];
  List<String> departmentOptions = const ['الكل'];
  List<String> officeOptions = const ['الكل'];
  List<String> statusOptions = const ['الكل'];

  final _isLoading = ValueNotifier<bool>(false);
  ValueNotifier<bool> get isLoading => _isLoading;

  final _error = ValueNotifier<String?>(null);
  ValueNotifier<String?> get error => _error;

  final _tick = ValueNotifier<int>(0);
  ValueNotifier<int> get tick => _tick;

  Timer? _debounce;

  void dispose() {
    _debounce?.cancel();
    _isLoading.dispose();
    _error.dispose();
    _tick.dispose();
  }

  Future<void> init() async {
    await reloadFiltersCascading();await reloadDashboard();
    await reloadItems();await reloadDashboard();
  }
  Future<void> reloadDashboard() async {
    statusCounts = await AppDb.instance.countByStatus();
    _tick.value++;
  }
  Future<void> reloadFilters() async {
    try {
      final map = await AppDb.instance.getAllDistinctFilters();
      typeOptions = map['type'] ?? ['الكل'];
      departmentOptions = map['department'] ?? ['الكل'];
      officeOptions = map['office'] ?? ['الكل'];
      statusOptions = map['status'] ?? ['الكل'];
      _tick.value++;
    } catch (e) {
      _error.value = e.toString();
    }
  }
  Future<void> reloadItems() async {
    _isLoading.value = true;
    _error.value = null;

    try {
      totalCount = await AppDb.instance.countFilteredEquipment(
        smartQuery: smartQ,
        type: type,
        department: department,
        office: office,
        status: status,
      );


      // إذا الفلاتر خلت النتائج أقل، تأكد الصفحة ما تخرجش برا
      final tp = totalPages;
      if (page >= tp) page = tp - 1;
      if (page < 0) page = 0;

      final data = await AppDb.instance.getFilteredEquipmentPaged(
        smartQuery: smartQ,
        type: type,
        department: department,
        office: office,
        status: status,
        limit: pageSize,
        offset: page * pageSize,
      );

      _items
        ..clear()
        ..addAll(data);

      _tick.value++;
    } catch (e) {
      _error.value = e.toString();
    } finally {
      _isLoading.value = false;
    }
  }

  void setSmartQuery(String v) {
    smartQ = v;
    page = 0;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      await reloadItems();
      await reloadFiltersCascading(); // لأنك اخترت cascading
    });
  }

  Future<void> setType(String v) async {
    type = v;
    page = 0;
    await reloadItems();
    await reloadFiltersCascading();
  }

  Future<void> setDepartment(String v) async {
    department = v;page = 0;
    await reloadItems();await reloadFiltersCascading();
  }

  Future<void> setOffice(String v) async {
    office = v;page = 0;
    await reloadItems();await reloadFiltersCascading();
  }

  Future<void> setStatus(String v) async {
    status = v;page = 0;
    await reloadItems();await reloadFiltersCascading();
  }
  Future<void> nextPage() async {
    if (page + 1 >= totalPages) return;
    page++;
    await reloadItems();
  }

  Future<void> prevPage() async {
    if (page <= 0) return;
    page--;
    await reloadItems();
  }

  Future<void> setPageSize(int v) async {
    pageSize = v;
    page = 0;
    await reloadItems();
  }
  Future<void> reloadFiltersCascading() async {
    try {
      // كل قائمة تتحدد بناءً على الفلاتر الحالية،
      // مع تجاهل عمودها حتى لا تحبس نفسها
      typeOptions = await AppDb.instance.getDistinctFiltered(
        column: 'type',
        smartQuery: smartQ,
        type: type,
        department: department,
        office: office,
        status: status,
        ignoreColumn: 'type',
      );

      departmentOptions = await AppDb.instance.getDistinctFiltered(
        column: 'department',
        smartQuery: smartQ,
        type: type,
        department: department,
        office: office,
        status: status,
        ignoreColumn: 'department',
      );

      officeOptions = await AppDb.instance.getDistinctFiltered(
        column: 'office',
        smartQuery: smartQ,
        type: type,
        department: department,
        office: office,
        status: status,
        ignoreColumn: 'office',
      );

      statusOptions = await AppDb.instance.getDistinctFiltered(
        column: 'status',
        smartQuery: smartQ,
        type: type,
        department: department,
        office: office,
        status: status,
        ignoreColumn: 'status',
      );

      // إذا القيمة المختارة لم تعد موجودة في القائمة الجديدة، رجّعها "الكل"
      if (!typeOptions.contains(type)) type = 'الكل';
      if (!departmentOptions.contains(department)) department = 'الكل';
      if (!officeOptions.contains(office)) office = 'الكل';
      if (!statusOptions.contains(status)) status = 'الكل';

      _tick.value++;
    } catch (e) {
      _error.value = e.toString();
    }
  }

}
