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
  final bool colorStatusColumn;  final double rowScale;
  final int? expandedColumnIndex;
  final double expandedColumnScale;

  const EquipmentPrintOptions({
    required this.isLandscape,
    required this.title,
    this.showPrintedAt = true,
    this.colorStatusColumn = true, this.rowScale = 1,
    this.expandedColumnIndex,
    this.expandedColumnScale = 1,
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
    final boldFont = await PdfGoogleFonts.notoNaskhArabicBold();   final titleStyle = pw.TextStyle(
      font: boldFont,  fontSize: 13,
      fontWeight: pw.FontWeight.bold,
    );
    final metaStyle = pw.TextStyle(
      font: regularFont,  fontSize: 10,
    );
    final headerStyle = pw.TextStyle(
      font: boldFont, fontSize: 9.5,
      fontWeight: pw.FontWeight.bold,
    );
    final cellStyle = pw.TextStyle(
      font: regularFont,  fontSize: 8.5,
    );  final horizontalPadding = 3.5;
    final verticalPadding = 3.0 * options.rowScale; if (rows.isEmpty) {
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
    } doc.addPage(
      pw.MultiPage(
        pageFormat: options.pageFormat,
        margin: const pw.EdgeInsets.all(20),
        textDirection: pw.TextDirection.rtl,
        header: (_) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(options.title, style: titleStyle),
            pw.SizedBox(height: 4),
            pw.Text('عدد السجلات: ${rows.length}', style: metaStyle),
            if (options.showPrintedAt) ...[
              pw.SizedBox(height: 2),
              pw.Text(
                'تاريخ الطباعة: ${DateTime.now().toLocal()}',
                style: metaStyle,
              ),],
            pw.SizedBox(height: 10),
          ],
        ), footer: (context) => pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            'الصفحة: ${context.pageNumber} / ${context.pagesCount}',
            style: metaStyle,
          ),
        ),
        build: (_) => [
          _buildTable(
            rows: rows,
            headerStyle: headerStyle,
            cellStyle: cellStyle,
            horizontalPadding: horizontalPadding,
            verticalPadding: verticalPadding,
            colorStatusColumn: options.colorStatusColumn,
            expandedColumnIndex: options.expandedColumnIndex,
            expandedColumnScale: options.expandedColumnScale,
          ),
        ],
      ),
    );

    return doc.save();
  }

  static pw.Widget _buildTable({
    required List<EquipmentData> rows,
    required pw.TextStyle headerStyle,
    required pw.TextStyle cellStyle,  required double horizontalPadding,
    required double verticalPadding,
    required bool colorStatusColumn,
    required int? expandedColumnIndex,
    required double expandedColumnScale,
  }) {
    final headerBg = PdfColors.grey300;

    final tableRows = <pw.TableRow>[
      pw.TableRow(
        repeat: true,
        decoration: pw.BoxDecoration(color: headerBg),
        children: [    _headerCell('الحالة', headerStyle, horizontalPadding, verticalPadding),
          _headerCell('المكتب', headerStyle, horizontalPadding, verticalPadding),
          _headerCell('الإدارة', headerStyle, horizontalPadding, verticalPadding),
          _headerCell(
            'الرقم التسلسلي',
            headerStyle,
            horizontalPadding,
            verticalPadding,
          ),
          _headerCell('الموديل', headerStyle, horizontalPadding, verticalPadding),
          _headerCell('النوع', headerStyle, horizontalPadding, verticalPadding),
          _headerCell('رقم الجرد', headerStyle, horizontalPadding, verticalPadding),
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
              cellStyle, horizontalPadding,
              verticalPadding,
              bg: colorStatusColumn ? statusColor : null,
            ), _dataCell(e.office, cellStyle, horizontalPadding, verticalPadding),
            _dataCell(e.department, cellStyle, horizontalPadding, verticalPadding),
            _dataCell(e.serial, cellStyle, horizontalPadding, verticalPadding),
            _dataCell(e.model, cellStyle, horizontalPadding, verticalPadding),
            _dataCell(e.type, cellStyle, horizontalPadding, verticalPadding),
            _dataCell(e.assetCode, cellStyle, horizontalPadding, verticalPadding),
          ],
        ),
      );
    }

    const compactColumnWidth = 0.9;
    final selectedScale = expandedColumnScale.clamp(0.7, 2.6);
    final columnWidths = <int, pw.TableColumnWidth>{
      for (var i = 0; i < 7; i++)
        i: pw.FlexColumnWidth(
          i == expandedColumnIndex
              ? compactColumnWidth * selectedScale
              : compactColumnWidth,
        ),
    };

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.5), columnWidths: columnWidths,
      children: tableRows,
    );
  } static pw.Widget _headerCell(
    String text,
    pw.TextStyle style,
    double horizontalPadding,
    double verticalPadding,
  ) {
    return pw.Padding( padding: pw.EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: style,
      ),
    );
  }

  static pw.Widget _dataCell(
    String text,
    pw.TextStyle style,double horizontalPadding,
    double verticalPadding, {
    PdfColor? bg,
  }) {
    return pw.Container(
      color: bg, padding: pw.EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: style,
      ),
    );
  }static PdfColor _statusColor(EquipmentStatus status) {
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