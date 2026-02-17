import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../data/excel_importer.dart';
import '../state/equipment_controller.dart';
// import 'add_equipment_page.dart'; // غير مستخدم حالياً
import 'widgets/filters_bar.dart';
import 'widgets/excel_table.dart';
import 'add_equipment_dialog.dart';

class EquipmentPage extends StatefulWidget {
  const EquipmentPage({super.key});

  @override
  State<EquipmentPage> createState() => _EquipmentPageState();
}

class _EquipmentPageState extends State<EquipmentPage> {
  late final EquipmentController c;

  @override
  void initState() {
    super.initState();
    c = EquipmentController();
    c.init();
  }

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final rebuild = Listenable.merge([c.tick, c.isLoading, c.error]);
    return AnimatedBuilder(
      animation: rebuild,
      builder: (context, _) {
        return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('سجل المعدات الإعلامية')),
        actions: [
          IconButton(
            tooltip: 'استيراد Excel',
            icon: const Icon(Icons.upload_file),
            onPressed: () async {
              final result = await FilePicker.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xlsx'],
              );

              if (result == null || result.files.single.path == null) return;

              final file = File(result.files.single.path!);

              try {
                final (inserted, skipped) = await ExcelImporter.importEquipment(file);

                await c.reloadFilters();
                await c.reloadDashboard();
                await c.reloadItems();

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'تم الاستيراد ✅ (أضيف: $inserted — تم تجاهل: $skipped)',
                    ),
                  ),
                );
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

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await AddEquipmentDialog.open(context, c);

        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة'),
      ),
      body: Column(
        children: [
          DashboardBar(controller: c),
          if (c.error.value != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: MaterialBanner(
                backgroundColor: Colors.red.shade50,
                content: Text(
                  '⚠️ ${c.error.value}',
                  textDirection: TextDirection.rtl,
                ),
                actions: [
                  TextButton(
                    onPressed: () => c.reloadItems(),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          FiltersBar(c: c),
          const SizedBox(height: 8),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(child: ExcelTable(items: c.items, controller: c)),
                if (c.isLoading.value) const Positioned(left: 0, right: 0, top: 0, child: LinearProgressIndicator(minHeight: 3)),
              ],
            ),
          ),
          _PagerBar(c: c),
        ],
      ),
        );
      },
    );
  }
}

class _PagerBar extends StatelessWidget {
  final EquipmentController c;
  const _PagerBar({required this.c});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Text('المجموع: ${c.totalCount}'),
            const Spacer(),

            // Page size
            SizedBox(
              width: 170,
              child: DropdownButtonFormField<int>(
                value: c.pageSize,
                isDense: true,
                decoration: const InputDecoration(
                  labelText: 'عرض',
                  border: OutlineInputBorder(),
                ),
                items: const [10, 25, 50, 100]
                    .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  c.setPageSize(v);
                },
              ),
            ),

            const SizedBox(width: 10),

            IconButton(
              tooltip: 'السابق',
              onPressed: c.page == 0 ? null : () => c.prevPage(),
              icon: const Icon(Icons.chevron_right),
            ),

            Text('صفحة ${c.page + 1} / ${c.totalPages}'),

            IconButton(
              tooltip: 'التالي',
              onPressed: (c.page + 1 >= c.totalPages) ? null : () => c.nextPage(),
              icon: const Icon(Icons.chevron_left),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardBar extends StatelessWidget {
  final EquipmentController controller;
  const DashboardBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {

  return AnimatedBuilder(
        animation: controller.tick,
        builder: (context, _) {    final m = controller.statusCounts;

        Widget card(String title, String status, IconData icon, Color color) {
          final count = m[status] ?? 0;
          return Expanded(
            child: InkWell(
              onTap: () => controller.setStatus(status),
              child: Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Icon(icon, color: color, size: 28),
                      const SizedBox(height: 6),
                      Text('$count', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text(title),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        return Row(
      children: [
        card('يعمل', 'يعمل', Icons.check_circle, Colors.green),
        card('تحتاج صيانة', 'تحتاج صيانة', Icons.warning, Colors.orange),
        card('في التصليح', 'في التصليح', Icons.build, Colors.blue),
        card('خارج الخدمة', 'خارج الخدمة', Icons.block, Colors.red),
      ],
    );
  });
}}