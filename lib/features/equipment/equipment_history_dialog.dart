import 'package:flutter/material.dart';
import '../../data/app_database.dart';
import '../../data/tables.dart';

Future<void> showEquipmentHistoryDialog(
    BuildContext context, {
      required AppDatabase db,
      required EquipmentData equipment,
    }) async {
  await showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('سجل الحركة - ${equipment.assetCode}'),
      content: SizedBox(
        width: 800,
        height: 420,
        child: StreamBuilder<List<EquipmentHistoryData>>(
          stream: db.equipmentDao.watchHistory(equipment.id),
          builder: (context, snap) {
            final data = snap.data ?? [];

            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (data.isEmpty) {
              return const Center(child: Text('لا يوجد سجل حتى الآن'));
            }

            return ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final h = data[i];
                return ListTile(
                  leading: const Icon(Icons.history),
                  title: Text(
                    '${_statusText(h.oldStatus)}  ←  ${_statusText(h.newStatus)}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    [
                      'التاريخ: ${h.changedAt}',
                      if (h.comment != null && h.comment!.trim().isNotEmpty)
                        'ملاحظة: ${h.comment}',
                    ].join('\n'),
                  ),
                );
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إغلاق')),
      ],
    ),
  );
}

String _statusText(EquipmentStatus? s) {
  if (s == null) return '-';
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
