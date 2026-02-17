import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';import '../../data/app_database.dart';

import '../../data/tables.dart';

class EquipmentFormResult {
  final String assetCode;
  final String type;
  final String model;
  final String serial;
  final String department;
  final String office;
  final EquipmentStatus status;
  final String? notes;

  EquipmentFormResult({
    required this.assetCode,
    required this.type,
    required this.model,
    required this.serial,
    required this.department,
    required this.office,
    required this.status,
    this.notes,
  });
}

Future<EquipmentFormResult?> showEquipmentFormDialog(
    BuildContext context, {  required AppDatabase db,
      EquipmentFormResult? initial,
      bool isEdit = false,
    }) async {
  final assetCtrl = TextEditingController(text: initial?.assetCode ?? '');
  final typeCtrl = TextEditingController(text: initial?.type ?? '');
  final modelCtrl = TextEditingController(text: initial?.model ?? '');
  final serialCtrl = TextEditingController(text: initial?.serial ?? '');
  final deptCtrl = TextEditingController(text: initial?.department ?? '');
  final officeCtrl = TextEditingController(text: initial?.office ?? '');
  final notesCtrl = TextEditingController(text: initial?.notes ?? '');

  EquipmentStatus status = initial?.status ?? EquipmentStatus.working;

  final formKey = GlobalKey<FormState>();

  return showDialog<EquipmentFormResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {late Future<List<String>> typesFuture;
    late Future<List<String>> departmentsFuture;
    late Future<List<String>> officesFuture;
    late Future<List<String>> modelsFuture;
    typesFuture = db.equipmentDao.getDistinctTypesFiltered();
    departmentsFuture = db.equipmentDao.getDistinctDepartmentsFiltered();
    officesFuture = db.equipmentDao.getDistinctOfficesFiltered();
    modelsFuture = db.equipmentDao.getDistinctModelsFiltered();  // ← new DAO method
      return AlertDialog(
        title: Center(child: Text(isEdit ? 'تحديث معدّة' : 'إضافة معدّة')),
        content: SizedBox(
          width: 700,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 12,
                runSpacing: 2.h,
                children: [
                  _field(assetCtrl, 'Asset Code (رقم الجرد)', requiredField: !isEdit, enabled: !isEdit),

                  FutureBuilder<List<String>>(
                    future: typesFuture,
                    builder: (context, snapshot) {
                      final options = snapshot.data ?? [];

                      return SizedBox(
                        width: 320,
                        child: Autocomplete<String>(
                          initialValue: TextEditingValue(text: typeCtrl.text),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return options;
                            }
                            return options.where((option) =>
                                option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (selection) {
                            typeCtrl.text = selection;
                          },
                          fieldViewBuilder:
                              (context, controller, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              onChanged: (value) => typeCtrl.text = value,
                              decoration: const InputDecoration(
                                labelText: 'النوع (كاميرا/ميكروفون/...)',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),



                  FutureBuilder<List<String>>(
                    future: modelsFuture,
                    builder: (context, snapshot) {
                      final options = snapshot.data ?? [];

                      return SizedBox(
                        width: 320,
                        child: Autocomplete<String>(
                          initialValue: TextEditingValue(text: modelCtrl.text),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return options;
                            }
                            return options.where((option) =>
                                option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (selection) {
    modelCtrl.text = selection;
                          },
                          fieldViewBuilder:
                              (context, controller, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,
                              onChanged: (value) => typeCtrl.text = value,
                              decoration: const InputDecoration(
                                labelText: 'الموديل',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

_field(serialCtrl, 'الرقم التسلسلي', requiredField: true),


                  FutureBuilder<List<String>>(
                    future: departmentsFuture,
                    builder: (context, snapshot) {
                      final options = snapshot.data ?? [];

                      return SizedBox(
                        width: 320,
                        child: Autocomplete<String>(
                          initialValue: TextEditingValue(text: deptCtrl.text),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return options;
                            }
                            return options.where((option) =>
                                option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (selection) {
    deptCtrl.text = selection;
                          },
                          fieldViewBuilder:
                              (context, controller, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode, onChanged: (value) => deptCtrl.text = value,
                              decoration: const InputDecoration(
                                labelText:'الإدارة المالكة',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  FutureBuilder<List<String>>(
                    future: officesFuture,
                    builder: (context, snapshot) {
                      final options = snapshot.data ?? [];

                      return SizedBox(
                        width: 320,
                        child: Autocomplete<String>(
                          initialValue: TextEditingValue(text: officeCtrl.text),
                          optionsBuilder: (TextEditingValue textEditingValue) {
                            if (textEditingValue.text.isEmpty) {
                              return options;
                            }
                            return options.where((option) =>
                                option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase()));
                          },
                          onSelected: (selection) {
                            officeCtrl.text = selection;
                          },
                          fieldViewBuilder:
                              (context, controller, focusNode, onFieldSubmitted) {
                            return TextFormField(
                              controller: controller,
                              focusNode: focusNode,onChanged: (value) => officeCtrl.text = value,
                              decoration: const InputDecoration(
                                labelText:'المكتب/الموقع',
                                border: OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'هذا الحقل مطلوب';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    width: 660,
                    child: TextFormField(
                      controller: notesCtrl,
                      decoration:   InputDecoration(floatingLabelAlignment: FloatingLabelAlignment.center, labelStyle: TextStyle(fontSize: 2.h),
                        labelText: 'ملاحظات',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(null),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;

              Navigator.of(ctx).pop(
                EquipmentFormResult(
                  assetCode: assetCtrl.text.trim(),
                  type: typeCtrl.text.trim(),
                  model: modelCtrl.text.trim(),
                  serial: serialCtrl.text.trim(),
                  department: deptCtrl.text.trim(),
                  office: officeCtrl.text.trim(),
                  status: status,
                  notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
                ),
              );
            },
            child: const Text('حفظ'),
          ),
        ],
      );
    },
  );
}

Widget _field(
    TextEditingController c,
    String label, {
      required bool requiredField,
      bool enabled = true,
    }) {
  return SizedBox(
    width: 320,
    child:
    TextFormField(
      controller: c,
      enabled: enabled,
      decoration: InputDecoration(  floatingLabelAlignment: FloatingLabelAlignment.center,
        labelText: label,labelStyle: TextStyle(fontSize: 2.h),
        border: const OutlineInputBorder(),
      ),
      validator: (v) {
        if (!requiredField) return null;
        if (v == null || v.trim().isEmpty) return 'هذا الحقل مطلوب';
        return null;
      },
    ),
  );
}
