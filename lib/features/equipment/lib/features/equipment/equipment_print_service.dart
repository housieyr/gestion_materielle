import 'dart:math' as math;
import 'dart:typed_data';

import 'package:gestion_materiel/data/app_database.dart';
import 'package:gestion_materiel/data/tables.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

 

class EquipmentPrintOptions {
  final bool isLandscape;
  final String title;
  final bool showPrintedAt;
  final bool colorStatusColumn;
  final int rowsPerPage;
  final double tableScale;

  const EquipmentPrintOptions({
    required this.isLandscape,
    required this.title,
    this.showPrintedAt = true,
    this.colorStatusColumn = true,
    this.rowsPerPage = 22,
    this.tableScale = 1,
  });

  PdfPageFormat get pageFormat =>
      isLandscape ? PdfPageFormat.a4.landscape : PdfPageFormat.a4;
}

class EquipmentPrintService {
  static Future<Uint8List> buildPdfBytes({
    required List<EquipmentData> rows,
    required EquipmentPrintOptions options,
  }) async {
    final doc = pw.Document();

    final regularFont = await PdfGoogleFonts.notoNaskhArabicRegular();
    final boldFont = await PdfGoogleFonts.notoNaskhArabicBold();

    final safeRowsPerPage = math.max(5, options.rowsPerPage);
    final chunks = _chunkRows(rows, safeRowsPerPage);
    final totalPages = math.max(1, chunks.length);

    final titleStyle = pw.TextStyle(
      font: boldFont,
      fontSize: 13 * options.tableScale,
      fontWeight: pw.FontWeight.bold,
    );
    final metaStyle = pw.TextStyle(
      font: regularFont,
      fontSize: 10 * options.tableScale,
    );
    final headerStyle = pw.TextStyle(
      font: boldFont,
      fontSize: 9.5 * options.tableScale,
      fontWeight: pw.FontWeight.bold,
    );
    final cellStyle = pw.TextStyle(
      font: regularFont,
      fontSize: 8.5 * options.tableScale,
    );
    final cellPadding = 4.5 * options.tableScale;

    if (chunks.isEmpty) {
      doc.addPage(
        pw.Page(
          pageFormat: options.pageFormat,
          margin: const pw.EdgeInsets.all(20),
          build: (_) => pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Center(
              child: pw.Text('لا توجد بيانات للطباعة', style: titleStyle),
            ),
          ),
        ),
      );
      return doc.save();
    }

    for (var i = 0; i < chunks.length; i++) {
      final pageRows = chunks[i];
      final pageNo = i + 1;

      doc.addPage(
        pw.Page(
          pageFormat: options.pageFormat,
          margin: const pw.EdgeInsets.all(20),
          build: (_) {
            return pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(options.title, style: titleStyle),
                  pw.SizedBox(height: 4),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('الصفحة: $pageNo / $totalPages', style: metaStyle),
                      pw.Text('عدد السجلات: ${rows.length}', style: metaStyle),
                    ],
                  ),
                  if (options.showPrintedAt) ...[
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'تاريخ الطباعة: ${DateTime.now().toLocal()}',
                      style: metaStyle,
                    ),
                  ],
                  pw.SizedBox(height: 10),
                  _buildTable(
                    rows: pageRows,
                    headerStyle: headerStyle,
                    cellStyle: cellStyle,
                    cellPadding: cellPadding,
                    colorStatusColumn: options.colorStatusColumn,
                  ),
                ],
              ),
            );
          },
        ),
      );
    }

    return doc.save();
  }

  static pw.Widget _buildTable({
    required List<EquipmentData> rows,
    required pw.TextStyle headerStyle,
    required pw.TextStyle cellStyle,
    required double cellPadding,
    required bool colorStatusColumn,
  }) {
    final headerBg = PdfColors.grey300;

    final tableRows = <pw.TableRow>[
      pw.TableRow(
        decoration: pw.BoxDecoration(color: headerBg),
        children: [
          _headerCell('الحالة', headerStyle, cellPadding),
          _headerCell('المكتب', headerStyle, cellPadding),
          _headerCell('الإدارة', headerStyle, cellPadding),
          _headerCell('الرقم التسلسلي', headerStyle, cellPadding),
          _headerCell('الموديل', headerStyle, cellPadding),
          _headerCell('النوع', headerStyle, cellPadding),
          _headerCell('رقم الجرد', headerStyle, cellPadding),
        ],
      ),
    ];

    for (final e in rows) {
      final statusColor = _statusColor(e.status);
      tableRows.add(
        pw.TableRow(
          children: [
            _dataCell(
              _statusLabel(e.status),
              cellStyle,
              cellPadding,
              bg: colorStatusColumn ? statusColor : null,
            ),
            _dataCell(e.office, cellStyle, cellPadding),
            _dataCell(e.department, cellStyle, cellPadding),
            _dataCell(e.serial, cellStyle, cellPadding),
            _dataCell(e.model, cellStyle, cellPadding),
            _dataCell(e.type, cellStyle, cellPadding),
            _dataCell(e.assetCode, cellStyle, cellPadding),
          ],
        ),
      );
    }

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(1.5),
        1: const pw.FlexColumnWidth(1.4),
        2: const pw.FlexColumnWidth(1.6),
        3: const pw.FlexColumnWidth(1.8),
        4: const pw.FlexColumnWidth(1.6),
        5: const pw.FlexColumnWidth(1.5),
        6: const pw.FlexColumnWidth(1.2),
      },
      children: tableRows,
    );
  }

  static pw.Widget _headerCell(String text, pw.TextStyle style, double padding) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(padding),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: style,
      ),
    );
  }

  static pw.Widget _dataCell(
    String text,
    pw.TextStyle style,
    double padding, {
    PdfColor? bg,
  }) {
    return pw.Container(
      color: bg,
      padding: pw.EdgeInsets.all(padding),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: style,
      ),
    );
  }

  static List<List<EquipmentData>> _chunkRows(List<EquipmentData> rows, int size) {
    if (rows.isEmpty) return const [];
    final out = <List<EquipmentData>>[];
    for (var i = 0; i < rows.length; i += size) {
      final end = math.min(i + size, rows.length);
      out.add(rows.sublist(i, end));
    }
    return out;
  }

  static PdfColor _statusColor(EquipmentStatus status) {
    switch (status) {
      case EquipmentStatus.working:
        return PdfColor.fromHex('#DFF4E5');
      case EquipmentStatus.needsMaintenance:
        return PdfColor.fromHex('#FFF1DC');
      case EquipmentStatus.inRepair:
        return PdfColor.fromHex('#DDEEFF');
      case EquipmentStatus.outOfService:
        return PdfColor.fromHex('#FFE0E0');
    }
  }

  static String _statusLabel(EquipmentStatus status) {
    switch (status) {
      case EquipmentStatus.working:
        return 'تعمل';
      case EquipmentStatus.needsMaintenance:
        return 'تحتاج صيانة';
      case EquipmentStatus.inRepair:
        return 'في التصليح';
      case EquipmentStatus.outOfService:
        return 'خارج الخدمة';
    }
  }
}