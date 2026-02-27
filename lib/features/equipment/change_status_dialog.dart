import 'package:flutter/material.dart';
import '../../data/tables.dart';

class ChangeStatusResult {
  final EquipmentStatus newStatus;
  final String? comment;

  ChangeStatusResult({required this.newStatus, this.comment});
}

Future<ChangeStatusResult?> showChangeStatusDialog(  BuildContext context, {
  required EquipmentStatus current,
}) async {
  EquipmentStatus selected = current;
  final ticketCtrl = TextEditingController();
  final commentCtrl = TextEditingController();

  return showDialog<ChangeStatusResult>(
    context: context,
    barrierDismissible: false,builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) {
        final mustTicket =
            selected == EquipmentStatus.inRepair ||
            selected == EquipmentStatus.outOfService;

  return AlertDialog(
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
                    DropdownMenuItem(
                      value: EquipmentStatus.working,
                      child: Text('✅ تعمل'),
                    ),
                    DropdownMenuItem(
                      value: EquipmentStatus.needsMaintenance,
                      child: Text('⚠️ تحتاج صيانة'),
                    ),
                    DropdownMenuItem(
                      value: EquipmentStatus.inRepair,
                      child: Text('🛠️ في التصليح'),
                    ),
                    DropdownMenuItem(
                      value: EquipmentStatus.outOfService,
                      child: Text('❌ خارج الخدمة'),
                    ),
                  ],
                  onChanged: (v) => setState(() => selected = v ?? current),
                ),
                if (mustTicket) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: ticketCtrl,
                    decoration: const InputDecoration(
                      labelText: 'رقم التصليح/السيسات',
                      hintText: 'مثال: SR-2026-015',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: commentCtrl,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظة إضافية (اختياري)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ], ),     ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),    ElevatedButton(
              onPressed: () {
                final ticket = ticketCtrl.text.trim();
                final comment = commentCtrl.text.trim(); if (mustTicket && ticket.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('رقم التصليح/السيسات مطلوب لهذه الحالة'),
                    ),
                  );
                  return;
                }   final combinedComment = [
                  if (ticket.isNotEmpty) 'رقم التصليح/السيسات: $ticket',
                  if (comment.isNotEmpty) comment,
                ].join('\n');

                Navigator.pop(
                  ctx,
                  ChangeStatusResult(
                    newStatus: selected,
                    comment: combinedComment.isEmpty ? null : combinedComment,
                  ),
                );
              },
              child: const Text('حفظ'),
            ), ],
        );
      },
    ),
  );
}