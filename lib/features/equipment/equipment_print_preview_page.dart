import 'dart:math' as math;
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../data/app_database.dart';
import '../../data/tables.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../../data/tables.dart';
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
  bool _colorStatusColumn = true;
  int _rowsPerPage = 22;
  double _tableScale = 1;

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
    colorStatusColumn: _colorStatusColumn,
    rowsPerPage: _rowsPerPage,
    tableScale: _tableScale,
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
                  SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<int>(
                      value: _rowsPerPage,
                      decoration: const InputDecoration(
                        labelText: 'سجلات لكل صفحة',
                        border: OutlineInputBorder(),
                      ),
                      items: const [10, 14, 18, 22, 26, 30, 34]
                          .map((n) => DropdownMenuItem(value: n, child: Text('$n')))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() => _rowsPerPage = v);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 340,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('حجم الجدول: ${_tableScale.toStringAsFixed(2)}x'),
                        Slider(
                          value: _tableScale,
                          min: 0.75,
                          max: 1.40,
                          divisions: 13,
                          label: _tableScale.toStringAsFixed(2),
                          onChanged: (v) => setState(() => _tableScale = v),
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
  }
}