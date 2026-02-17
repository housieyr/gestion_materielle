import 'package:flutter/material.dart';
import '../../data/tables.dart';

class ChangeStatusResult {
  final EquipmentStatus newStatus;
  final String? comment;

  ChangeStatusResult({required this.newStatus, this.comment});
}

Future<ChangeStatusResult?> showChangeStatusDialog(
    BuildContext context, {
      required EquipmentStatus current,
    }) async {
  EquipmentStatus selected = current;
  final commentCtrl = TextEditingController();

  return showDialog<ChangeStatusResult>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) =>


        AlertDialog(
      title: const Text('تغيير الحالة'),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<EquipmentStatus>(
              value: selected,
              decoration: const InputDecoration(
                labelText: 'الحالة الجديدة',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: EquipmentStatus.working, child: Text('✅ تعمل')),
                DropdownMenuItem(value: EquipmentStatus.needsMaintenance, child: Text('⚠️ تحتاج صيانة')),
                DropdownMenuItem(value: EquipmentStatus.inRepair, child: Text('🛠️ في التصليح')),
                DropdownMenuItem(value: EquipmentStatus.outOfService, child: Text('❌ خارج الخدمة')),
              ],
              onChanged: (v) => selected = v ?? current,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: commentCtrl,
              decoration: const InputDecoration(
                labelText: 'ملاحظة (اختياري)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
        ElevatedButton(
          onPressed: () {

            final comment = commentCtrl.text.trim();
            final mustComment = selected == EquipmentStatus.inRepair ||
                selected == EquipmentStatus.outOfService;

            if (mustComment && comment.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('الملاحظة مطلوبة لهذه الحالة')),
              );
              return;
            }
            Navigator.pop(
            ctx,
            ChangeStatusResult(
              newStatus: selected,
              comment: commentCtrl.text.trim().isEmpty ? null : commentCtrl.text.trim(),
            ),
          );  },
          child: const Text('حفظ'),
        ),
      ],
    ),
  );
}
