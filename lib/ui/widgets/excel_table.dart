import 'package:flutter/material.dart';
import '../../data/equipment.dart';
import '../../state/equipment_controller.dart';
import '../../data/app_db.dart';
import '../audit_dialog.dart';

class ExcelTable extends StatefulWidget {
  final List<Equipment> items;
  final EquipmentController controller;

  const ExcelTable({super.key, required this.items, required this.controller});

  @override
  State<ExcelTable> createState() => _ExcelTableState();
}

class MenuCell extends StatelessWidget {
  final String value;
  final List<String> options; // قيم سابقة
  final Future<void> Function(String selected) onSelected;

  const MenuCell({
    super.key,
    required this.value,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTapDown: (d) async {
        final pos = d.globalPosition;

        final clean = options
            .where((e) => e.trim().isNotEmpty && e != 'الكل')
            .toList();

        // إذا ماكانش خيارات، ما ندير والو
        if (clean.isEmpty) return;

        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(pos.dx, pos.dy, pos.dx, pos.dy),
          items: clean
              .map(
                (s) => PopupMenuItem<String>(
                  value: s,
                  child: SizedBox(
                    width: 260,
                    child: Text(s, overflow: TextOverflow.ellipsis),
                  ),
                ),
              )
              .toList(),
        );

        if (selected == null || selected == value) return;
        await onSelected(selected);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.arrow_drop_down, color: Colors.white),
        ],
      ),
    );
  }
}

class _ExcelTableState extends State<ExcelTable> {
  String? editingKey; // مثال: "id:field"

  void startEdit(int id, String field) {
    setState(() => editingKey = '$id:$field');
  }

  void stopEdit() {
    setState(() => editingKey = null);
  }

  bool isEditing(int id, String field) => editingKey == '$id:$field';
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 1100),
          child: SingleChildScrollView(
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(
                const Color(0xFFE6E6E6),
              ),
              columnSpacing: 18,
              dataRowMinHeight: 44,
              dataRowMaxHeight: 60,
              columns: [
                _col('ع/ر'),
                _colFilter('نوع العتاد'),
                _colFilter('المصنع'),
                _colFilter('الرقم التسلسلي'),
                _colFilter('الهيكل'),
                _colFilter('المكتب'),
                _colFilter('الملاحظات'),_col('سجل'),
              ],
              rows: List<DataRow>.generate(widget.items.length, (i) {
                final e = widget.items[i];
                final rowColor = (i % 2 == 0)
                    ? const Color(0xFFdAfE88)
                    :   Color(0xFFdAfE88);
                return DataRow(
                  color: MaterialStateProperty.resolveWith((_) => rowColor),
                  cells: [
                    _cell('${e.inventoryNumber}'),

                    DataCell( 
                      MenuCell(
                        value: e.type,
                        options: widget
                            .controller
                            .typeOptions, // من المعطيات السابقة
                        onSelected: (selected) async {
                          await AppDb.instance.updateFieldLogged(
                            id: e.id!,
                            field: 'type',
                            value: selected,
                          );
                          await widget.controller
                              .reloadFiltersCascading(); // لأن الخيارات تتغير
                          await widget.controller.reloadItems();
                        },
                      ),
                    ),
                    DataCell(
                      EditableCell(
                        initialValue: e.manufacturer,
                        editing: isEditing(e.id!, 'manufacturer'),
                        onDoubleTap: () => startEdit(e.id!, 'manufacturer'),
                        onCommit: (v) async {
                          // حفظ
                          await AppDb.instance.updateFieldLogged(
                            id: e.id!,
                            field: 'manufacturer',
                            value: v,
                          );
                          stopEdit();
                          await widget.controller
                              .reloadFiltersCascading(); // لأن القيم الجديدة قد تدخل في الفلاتر
                          await widget.controller.reloadItems(); // تحديث الجدول
                          return true;
                        },
                      ),
                    ),
                    DataCell(
                      EditableCell(
                        initialValue: e.serialNumber,
                        editing: isEditing(e.id!, 'serialNumber'),
                        onDoubleTap: () => startEdit(e.id!, 'serialNumber'),
                        onCommit: (v) async {
                          try {
                            await AppDb.instance.updateFieldLogged(
                              id: e.id!,
                              field: 'serialNumber',
                              value: v,
                            );
                            stopEdit();
                            await widget.controller.reloadItems();
                            return true;
                          } catch (_) {
                            // لو مكرر
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'هذا الرقم التسلسلي موجود مسبقًا.',
                                ),
                              ),
                            );
                            // لا نوقف التعديل حتى يصحح
                            return false;
                          }
                        },
                      ),
                    ),

                    DataCell(
                      EditableCell(
                        initialValue: e.department,
                        editing: isEditing(e.id!, 'department'),
                        onDoubleTap: () => startEdit(e.id!, 'department'),
                        onCommit: (v) async {
                          // حفظ
                          await AppDb.instance.updateFieldLogged(
                            id: e.id!,
                            field: 'department',
                            value: v,
                          );
                          stopEdit();
                          await widget.controller
                              .reloadFiltersCascading(); // لأن القيم الجديدة قد تدخل في الفلاتر
                          await widget.controller.reloadItems(); // تحديث الجدول
                          return true;
                        },
                      ),
                    ),
                    DataCell(
                      EditableCell(
                        initialValue: e.office,
                        editing: isEditing(e.id!, 'office'),
                        onDoubleTap: () => startEdit(e.id!, 'office'),
                        onCommit: (v) async {
                          // حفظ
                          try {
                            await AppDb.instance.updateFieldLogged(id: e.id!, field: 'office', value: v);
                            stopEdit();
                            await widget.controller.reloadFiltersCascading();
                            await widget.controller.reloadItems();
                            return true;
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                            return false; // يبقى في edit
                          }
                        },
                      ),
                    ),

                    DataCell(
                      MenuCell(
                        value: e.status,
                        options: statuses, // بدل list ثابتة
                        onSelected: (selected) async {
                          try {
                            await AppDb.instance.updateFieldLogged(
                              id: e.id!,
                              field: 'status',
                              value: selected,
                            );

                            // ✅ تحديث الليست + الداشبورد اللي فوق (counts)
                            await widget.controller.reloadDashboard();
                            await widget.controller.reloadItems();

                            // إذا تحب status يدخل/يخرج من الفلاتر مستقبلاً
                            // (حاليا statuses ثابتة، لكن هذا آمن)
                            await widget.controller.reloadFiltersCascading();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }
                        },
                      ),
                    ),DataCell(
                      IconButton(
                        icon: const Icon(Icons.history, color: Colors.white),
                        onPressed: () {
                          if (e.id == null) return;
                          AuditDialog.open(context, e.id!);
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  DataColumn _col(String t) => DataColumn(
    label: Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
  );

  DataColumn _colFilter(String t) => DataColumn(
    label: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(t, style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(width: 6),
        const Icon(Icons.filter_alt, size: 18, color: Colors.black54),
      ],
    ),
  );

  DataCell _cell(String v) => DataCell(
    Text(
      v,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
    ),
  );
}

final statuses = ['يعمل', 'تحتاج صيانة', 'في التصليح', 'خارج الخدمة'];

class EditableCell extends StatefulWidget {
  final String initialValue;
  final bool editing;
  final VoidCallback onDoubleTap;
  final Future<bool> Function(String newValue)
  onCommit; // يرجع true إذا تم الحفظ
  final TextInputType keyboardType;

  const EditableCell({
    super.key,
    required this.initialValue,
    required this.editing,
    required this.onDoubleTap,
    required this.onCommit,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<EditableCell> createState() => _EditableCellState();
}

Widget StatusCell({
  required BuildContext context,
  required String value,
  required VoidCallback onDoubleTap,
}) {
  return InkWell(
    onDoubleTap: onDoubleTap,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.arrow_drop_down, color: Colors.white),
      ],
    ),
  );
}

class _EditableCellState extends State<EditableCell> {
  late final TextEditingController _c;
  final FocusNode _f = FocusNode();

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant EditableCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.editing != widget.editing && widget.editing) {
      _c.text = widget.initialValue;
      // autofocus عند الدخول للتعديل
      Future.microtask(() {
        _f.requestFocus();
        _c.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _c.text.length,
        );
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    _f.dispose();
    super.dispose();
  }

  Future<void> _commit() async {
    final v = _c.text.trim();
    if (v == widget.initialValue.trim()) return; // لا تغيير
    await widget.onCommit(v);
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.editing) {
      return InkWell(
        onDoubleTap: widget.onDoubleTap,
        child: Text(
          widget.initialValue,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Focus(
      onFocusChange: (hasFocus) async {
        // ✅ عند الخروج من الخلية: نحفظ تلقائيًا
        if (!hasFocus) {
          await _commit();
        }
      },
      onKeyEvent: (node, e) {
        // Esc يلغي: يرجع القيمة الأصلية ويخرج
        if (e.logicalKey.keyLabel.toLowerCase() == 'escape') {
          _c.text = widget.initialValue;
          FocusScope.of(context).unfocus();
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: TextField(
        controller: _c,
        focusNode: _f,
        keyboardType: widget.keyboardType,
        onSubmitted: (_) => _commit(), // Enter = حفظ
        decoration: const InputDecoration(
          isDense: true,
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        ),
      ),
    );
  }
}
