import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../data/app_database.dart';
 
import 'lib/features/equipment/equipment_print_service.dart';

class EquipmentPrintPreviewPage extends StatefulWidget {
  final List<EquipmentData> rows;

  const EquipmentPrintPreviewPage({super.key, required this.rows});

  @override
  State<EquipmentPrintPreviewPage> createState() =>
      _EquipmentPrintPreviewPageState();
}

class _EquipmentPrintPreviewPageState extends State<EquipmentPrintPreviewPage> {
  bool _isLandscape = true;
  bool _showPrintedAt = true;
  bool _colorStatusColumn = true;double _rowScale = 1;
  int? _expandedColumnIndex;
  double _expandedColumnScale = 1.3;

  static const List<String> _columnTitles = [
    'الحالة',
    'المكتب',
    'الإدارة',
    'الرقم التسلسلي',
    'الموديل',
    'النوع',
    'رقم الجرد',
  ];

  final TextEditingController _titleCtrl =
      TextEditingController(text: 'تقرير المعدات');

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  EquipmentPrintOptions get _options => EquipmentPrintOptions(
    isLandscape: _isLandscape,
    title: _titleCtrl.text.trim().isEmpty ? 'تقرير المعدات' : _titleCtrl.text,
    showPrintedAt: _showPrintedAt,
    colorStatusColumn: _colorStatusColumn, rowScale: _rowScale,
    expandedColumnIndex: _expandedColumnIndex,
    expandedColumnScale: _expandedColumnScale,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('معاينة الطباعة'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'عنوان التقرير',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    width: 210,
                    child: DropdownButtonFormField<bool>(
                      value: _isLandscape,
                      decoration: const InputDecoration(
                        labelText: 'اتجاه الصفحة',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: true, child: Text('أفقي')),
                        DropdownMenuItem(value: false, child: Text('عمودي')),
                      ],
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _isLandscape = v);
                      },
                    ),
                  ),
                  SizedBox(   width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('تكبير ارتفاع السطر: ${_rowScale.toStringAsFixed(2)}x'),
                        Slider(
                          value: _rowScale,
                          min: 0.85,
                          max: 1.9,
                          divisions: 21,
                          label: _rowScale.toStringAsFixed(2),
                          onChanged: (v) => setState(() => _rowScale = v),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: DropdownButtonFormField<int?>(
                      value: _expandedColumnIndex,
                      decoration: const InputDecoration(  labelText: 'تكبير عمود محدد',
                        border: OutlineInputBorder(),
                      ),items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('بدون (كل الأعمدة صغيرة)'),
                        ),
                        ...List.generate(
                          _columnTitles.length,
                          (i) => DropdownMenuItem<int?>(
                            value: i,
                            child: Text(_columnTitles[i]),
                          ),
                        ),
                      ],
                      onChanged: (v) => setState(() => _expandedColumnIndex = v),
                    ),
                  ),
                  SizedBox( width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [  Text(
                          'نسبة تكبير العمود المحدد: ${_expandedColumnScale.toStringAsFixed(2)}x',
                        ),
                        Slider(    value: _expandedColumnScale,
                          min: 0.7,
                          max: 2.6,
                          divisions: 19,
                          label: _expandedColumnScale.toStringAsFixed(2),
                          onChanged: _expandedColumnIndex == null
                              ? null
                              : (v) => setState(() => _expandedColumnScale = v),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _showPrintedAt,
                        onChanged: (v) => setState(() => _showPrintedAt = v ?? true),
                      ),
                      const Text('إظهار تاريخ الطباعة'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: _colorStatusColumn,
                        onChanged: (v) => setState(() => _colorStatusColumn = v ?? true),
                      ),
                      const Text('تلوين عمود الحالة'),
                    ],
                  ),
                  Chip(label: Text('السجلات: ${widget.rows.length}')),
                ],
              ),
            ),
          ),
          Expanded(
            child: PdfPreview(
              canChangeOrientation: false,
              canChangePageFormat: false,
              canDebug: false,
              maxPageWidth: 1200,
              build: (_) => EquipmentPrintService.buildPdfBytes(
                rows: widget.rows,
                options: _options,
              ),
            ),
          ),
        ],
      ),
    );
  }}