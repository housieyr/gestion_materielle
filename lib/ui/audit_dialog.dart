import 'package:flutter/material.dart';
import '../data/app_db.dart';

class AuditDialog extends StatelessWidget {
  final int equipmentId;
  const AuditDialog({super.key, required this.equipmentId});

  static Future<void> open(BuildContext context, int equipmentId) {
    return showDialog(
      context: context,
      builder: (_) => AuditDialog(equipmentId: equipmentId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text('سجل التغييرات', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
                    ),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 10),

                FutureBuilder(
                  future: AppDb.instance.getAuditForEquipment(equipmentId),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final rows = snap.data!;
                    if (rows.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(18),
                        child: Text('لا يوجد تغييرات مسجلة بعد.'),
                      );
                    }

                    return SizedBox(
                      height: 420,
                      child: ListView.separated(
                        itemCount: rows.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final r = rows[i];
                          final at = (r['at'] ?? '').toString();
                          final action = (r['action'] ?? '').toString();
                          final field = (r['field'] ?? '').toString();
                          final oldV = (r['oldValue'] ?? '').toString();
                          final newV = (r['newValue'] ?? '').toString();

                          return ListTile(
                            dense: true,
                            title: Text('$action  ${field.isEmpty ? '' : '• $field'}'),
                            subtitle: Text('من: $oldV  →  إلى: $newV'),
                            trailing: Text(at, textAlign: TextAlign.left),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}