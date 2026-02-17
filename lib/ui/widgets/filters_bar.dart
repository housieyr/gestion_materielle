import 'package:flutter/material.dart';
import '../../state/equipment_controller.dart';

class FiltersBar extends StatelessWidget {
  final EquipmentController c;
  const FiltersBar({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: LayoutBuilder(
          builder: (context, cons) {
            final w = cons.maxWidth;

            double fieldW;
            if (w >= 1200) {
              fieldW = (w - 40) / 5;
            } else if (w >= 900) fieldW = (w - 30) / 3;
            else if (w >= 600) fieldW = (w - 20) / 2;
            else fieldW = w;

            Widget box(Widget child) => SizedBox(width: fieldW, child: child);

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                box(TextField(
                  decoration: const InputDecoration(
                    labelText: 'بحث (رقم عدة / Serial / مكتب / مصنع …)',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: c.setSmartQuery,
                )),

                box(_drop(
                  label: 'نوع العتاد',
                  value: c.type,
                  options: c.typeOptions,
                  onChanged: (v) => c.setType(v ?? 'الكل'),
                )),

                box(_drop(
                  label: 'الهيكل',
                  value: c.department,
                  options: c.departmentOptions,
                  onChanged: (v) => c.setDepartment(v ?? 'الكل'),
                )),

                box(_drop(
                  label: 'المكتب',
                  value: c.office,
                  options: c.officeOptions,
                  onChanged: (v) => c.setOffice(v ?? 'الكل'),
                )),

                box(_drop(
                  label: 'الملاحظات',
                  value: c.status,
                  options: c.statusOptions,
                  onChanged: (v) => c.setStatus(v ?? 'الكل'),
                )),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _drop({
    required String label,
    required String value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {final uniq = options
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toSet()
      .toList();

// ✅ ترتيب: "الكل" في الأول، والباقي أبجدي
  uniq.sort();
  final cleaned = [
    if (uniq.contains('الكل')) 'الكل',
    ...uniq.where((e) => e != 'الكل'),
  ];

  final safeValue = cleaned.contains(value)
      ? value
      : (cleaned.isNotEmpty ? cleaned.first : null);
  return DropdownButtonFormField<String>(
      isExpanded: true,
      value: safeValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: cleaned
          .map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis)))
          .toList(),
    onChanged: cleaned.isEmpty ? null : onChanged,
    );
  }
}
