import 'package:flutter/material.dart';
import '../data/app_db.dart';
import '../data/equipment.dart';
import 'widgets/combo_field.dart';

import '../state/equipment_controller.dart'; // تأكد من وجوده


class AddEquipmentDialog extends StatefulWidget {
  final EquipmentController controller;

  const AddEquipmentDialog({
    super.key,
    required this.controller,
  });

  // ✅ هذه الدالة هي التي تنقصك
  static Future<bool?> open(
      BuildContext context,
      EquipmentController controller,
      ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEquipmentDialog(controller: controller),
    );
  }

  @override
  State<AddEquipmentDialog> createState() => _AddEquipmentDialogState();
}


class _AddEquipmentDialogState extends State<AddEquipmentDialog> {
  final _formKey = GlobalKey<FormState>();

  final _invCtrl = TextEditingController();     // رقم العدة
  final _serialCtrl = TextEditingController();  // serial
  final _manuCtrl = TextEditingController();    // المصنع
  final _notesCtrl = TextEditingController();   // ملاحظات

  // هذه الثلاثة: كتابة + اختيار
  final _typeCtrl = TextEditingController();
  final _deptCtrl = TextEditingController();
  final _officeCtrl = TextEditingController();

  bool _saving = false;

  String _status = 'يعمل';
  final _statusOptions = const ['يعمل', 'تحتاج صيانة', 'في التصليح', 'خارج الخدمة'];

  List<String> _typeOptions = [];
  List<String> _deptOptions = [];
  List<String> _officeOptions = [];

  @override
  void initState() {
    super.initState();
    _loadDefaults();
  }

  @override
  void dispose() {
    _invCtrl.dispose();
    _serialCtrl.dispose();
    _manuCtrl.dispose();
    _notesCtrl.dispose();
    _typeCtrl.dispose();
    _deptCtrl.dispose();
    _officeCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDefaults() async {
    final nextInv = await AppDb.instance.getNextInventoryNumber();
    final filters = await AppDb.instance.getAllDistinctFilters();

    setState(() {
      _invCtrl.text = '$nextInv';
      _typeOptions = (filters['type'] ?? const ['الكل']).where((e) => e != 'الكل').toList();
      _deptOptions = (filters['department'] ?? const ['الكل']).where((e) => e != 'الكل').toList();
      _officeOptions = (filters['office'] ?? const ['الكل']).where((e) => e != 'الكل').toList();
    });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  String? _req(String? v, String msg) {
    if (v == null || v.trim().isEmpty) return msg;
    return null;
  }

  Future<void> _save({required bool keepOpen}) async {
    if (_saving) return;

    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    final inv = int.tryParse(_invCtrl.text.trim());
    if (inv == null) {
      _snack('رقم العدة يجب أن يكون رقمًا صحيحًا.');
      return;
    }

    final type = _typeCtrl.text.trim();
    final dept = _deptCtrl.text.trim();
    final office = _officeCtrl.text.trim();

    if (type.isEmpty || dept.isEmpty || office.isEmpty) {
      _snack('الرجاء تعمير النوع والهيكل والمكتب.');
      return;
    }

    final serial = _serialCtrl.text.trim();
    final manu = _manuCtrl.text.trim();

    setState(() => _saving = true);

    try {
      // منع تكرار serial برسالة
      final exists = await AppDb.instance.serialExists(serial);
      if (exists) {
        _snack('هذا الرقم التسلسلي موجود مسبقًا.');
        return;
      }

      final item = Equipment(
        inventoryNumber: inv,
        type: type,
        manufacturer: manu,
        serialNumber: serial,
        department: dept,
        office: office,
        status: _status,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      );

      await AppDb.instance.insertEquipment(item);
      await widget.controller.reloadFilters();
      await widget.controller.reloadDashboard();
      await widget.controller.reloadItems();
      if (!mounted) return;

      if (keepOpen) {
        _snack('تمت الإضافة ✅');

        // تفريغ سريع + اقتراح رقم عدة جديد
        _serialCtrl.clear();
        _manuCtrl.clear();
        _notesCtrl.clear();

        _typeCtrl.clear();
        _deptCtrl.clear();
        _officeCtrl.clear();

        _status = 'يعمل';

        final nextInv = await AppDb.instance.getNextInventoryNumber();
        _invCtrl.text = '$nextInv';

        // تحديث قوائم الاختيار لأن المستخدم قد أضاف قيم جديدة
        await _loadDefaults();
      } else {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _snack('خطأ أثناء الحفظ: $e');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      insetPadding: const EdgeInsets.all(14),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: LayoutBuilder(
              builder: (context, cons) {
                // ✅ نجعل الديالوق لا يتجاوز 90% من ارتفاع الشاشة
                final maxH = MediaQuery.of(context).size.height * 0.90;

                return ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxH),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header ثابت (لا يتمرر)
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'إضافة معدّة',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                            ),
                          ),
                          IconButton(
                            onPressed: _saving ? null : () => Navigator.pop(context, false),
                            icon: const Icon(Icons.close),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ✅ الجسم يتمرر
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: LayoutBuilder(
                              builder: (context, cons2) {
                                final wide = cons2.maxWidth >= 720;
                                return GridView.count(
                                  crossAxisCount: wide ? 2 : 1,
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: wide ? 3.2 : 3.6,
                                  children: [
                                    // ✅ هنا نفس حقولك بالضبط بدون تغيير
                                    TextFormField(
                                      controller: _invCtrl,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'رقم العدة (ع/ر)',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      validator: (v) => _req(v, 'رقم العدة إجباري'),
                                    ),
                                    TextFormField(
                                      controller: _serialCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'الرقم التسلسلي (Serial)',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      validator: (v) => _req(v, 'الرقم التسلسلي إجباري'),
                                    ),
                                    TextFormField(
                                      controller: _manuCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'المصنع',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      validator: (v) => _req(v, 'المصنع إجباري'),
                                    ),

                                    ComboField(
                                      label: 'نوع العتاد',
                                      controller: _typeCtrl,
                                      options: _typeOptions,
                                      hint: 'اكتب نوع جديد أو اختر من السهم',
                                      validator: (v) => _req(v, 'نوع العتاد إجباري'),
                                    ),
                                    ComboField(
                                      label: 'الهيكل (الإدارة)',
                                      controller: _deptCtrl,
                                      options: _deptOptions,
                                      hint: 'اكتب قيمة جديدة أو اختر من السهم',
                                      validator: (v) => _req(v, 'الهيكل إجباري'),
                                    ),
                                    ComboField(
                                      label: 'المكتب',
                                      controller: _officeCtrl,
                                      options: _officeOptions,
                                      hint: 'اكتب مكتب جديد أو اختر من السهم',
                                      validator: (v) => _req(v, 'المكتب إجباري'),
                                    ),

                                    DropdownButtonFormField<String>(
                                      initialValue: _status,
                                      isExpanded: true,
                                      decoration: const InputDecoration(
                                        labelText: 'الحالة',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                      items: _statusOptions
                                          .map((s) => DropdownMenuItem(
                                        value: s,
                                        child: Text(s, overflow: TextOverflow.ellipsis),
                                      ))
                                          .toList(),
                                      onChanged: (v) => setState(() => _status = v ?? _status),
                                    ),

                                    TextFormField(
                                      controller: _notesCtrl,
                                      decoration: const InputDecoration(
                                        labelText: 'ملاحظات إضافية (اختياري)',
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Footer ثابت (لا يتمرر)
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _saving ? null : () => _save(keepOpen: false),
                              icon: _saving
                                  ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                                  : const Icon(Icons.save),
                              label: const Text('حفظ'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _saving ? null : () => _save(keepOpen: true),
                              icon: const Icon(Icons.playlist_add),
                              label: const Text('حفظ + جديد'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

        ),
      ),
    );
  }
}
