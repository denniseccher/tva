import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/classes/shift.class.dart';

// Future<void> writeAndRequestDownloadExcel({ BuildContext? context, required String month }) async {
//   var assetPath = "assets/template.xlsx";
//   var suggestedFileName = "$month.xlsx";

//   try {
//     // CARICAMENTO DEL TEMPLATE
//     final ByteData data = await rootBundle.load(assetPath);
//     var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     var excel = Excel.decodeBytes(bytes);

//     // ACCESSO AL FOGLIO
//     var sheet = excel.tables[excel.tables.keys.first];
//     if (sheet == null) {
//       // Se il foglio non c'è, do errore ed esco
//       return;
//     }

//     final desiredCellStyle = CellStyle(
//       fontSize: 12,
//       horizontalAlign: HorizontalAlign.Center,
//       verticalAlign: VerticalAlign.Center
//     );

//     var nameCell = CellIndex.indexByString('D3');
//     var nameCellValue = TextCellValue('Dennis Eccher');
//     sheet.updateCell(nameCell, nameCellValue, cellStyle: desiredCellStyle.copyWith(fontSizeVal: 20));

//     var monthCell = CellIndex.indexByString('E4');
//     var monthCellValue = TextCellValue(month);
//     sheet.updateCell(monthCell, monthCellValue, cellStyle: desiredCellStyle.copyWith(fontSizeVal: 20));


//     var ibanCell = CellIndex.indexByString('E5');
//     var ibanCellValue = TextCellValue('Iban qua');
//     sheet.updateCell(ibanCell, ibanCellValue, cellStyle: desiredCellStyle.copyWith(fontSizeVal: 20));

//     var dateCell = CellIndex.indexByString('F49');
//     var dateCellValue = DateCellValue.fromDateTime(DateTime.now());
//     sheet.updateCell(dateCell, dateCellValue, cellStyle: desiredCellStyle);

//     var dt = sheet.cell(
//       CellIndex.indexByString('A8')
//     );
//     dt.value = DateCellValue.fromDateTime(DateTime.now());
    
//     sheet.cell(
//       CellIndex.indexByString('B8')
//     ).value = IntCellValue(2);

//     // Definisci l'indice della cella target (D3)
//     final cellIndex = CellIndex.indexByString('C8');
//     final cellValue = TimeCellValue.fromDuration(Duration(minutes: 45));


//     sheet.updateCell(cellIndex, cellValue, cellStyle: desiredCellStyle);

//     // RICODIFICO I BYTES IN EXCEL
//     var fileBytes = excel.encode();
//     if (fileBytes == null) {
//       // Se non funziona, do errore ed esco
//       return;
//     }

//     // file_picker richiede Uint8List, quindi convertiamo se necessario
//     final Uint8List bytesToSave = Uint8List.fromList(fileBytes);

//     // RICHIESTA DI SALVATAGGIO DEL FILE
//     await FilePicker.platform.saveFile(
//       dialogTitle: 'Salva il file Excel',
//       fileName: suggestedFileName,
//       type: FileType.custom,
//       allowedExtensions: ['xlsx'],
//       bytes: bytesToSave,
//       lockParentWindow: true,
//     );

//   } catch (e) {
//     // TODO gestione errore
//   }
// }

class User {
  final String nome;
  final String cognome;
  final String iban;

  User({required this.nome, required this.cognome, required this.iban});
}


/// Functon to populate and save the excel file
Future<void> populateAndSaveReport({
  required BuildContext context,
  required User user,
  required List<Shift> allShifts,
  required int targetMonth,
  required int targetYear,
}) async {
  try {
    // Loading and access to sheet
    final assetPath = "assets/template.xlsx";
    final ByteData data = await rootBundle.load(assetPath);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excelDoc = excel.Excel.decodeBytes(bytes);

    // If there are no sheets in the file, exit
    if (excelDoc.tables.keys.isEmpty) {
      return;
    }
    // Here I'm saving the first page's key
    var sheetKey = excelDoc.tables.keys.first;
    var sheetObject = excelDoc.tables[sheetKey];

    // If I can't access the page, return
    if (sheetObject == null) {
      return;
    }

    // Styles
    // TODO try to change here, because sometimes they don't work
    var commonBorder = excel.Border(
      borderStyle: excel.BorderStyle.Thin,
    );

    var baseStyle = excel.CellStyle(
      fontFamily: 'Arial', // Font desiderato (verificare installazione!)
      fontSize: 12,
      horizontalAlign: excel.HorizontalAlign.Center,
      verticalAlign: excel.VerticalAlign.Center,
      leftBorder: commonBorder, // Usa definizione corretta
      rightBorder: commonBorder,
      topBorder: commonBorder,
      bottomBorder: commonBorder,
      bold: false
    );

    var headerStyle = excel.CellStyle(
      fontFamily: 'Arial', // Font desiderato (verificare installazione!)
      fontSize: 18,
      horizontalAlign: excel.HorizontalAlign.Center,
      verticalAlign: excel.VerticalAlign.Center,
      leftBorder: commonBorder, // Usa definizione corretta
      rightBorder: commonBorder,
      topBorder: commonBorder,
      bottomBorder: commonBorder,
      bold: false
    );

    var signatureStyle = excel.CellStyle(
      fontFamily: 'Brush Script MT', // Font desiderato (verificare installazione!)
      fontSize: 18,
      horizontalAlign: excel.HorizontalAlign.Center,
      verticalAlign: excel.VerticalAlign.Center,
      leftBorder: commonBorder, // Usa definizione corretta
      rightBorder: commonBorder,
      topBorder: commonBorder,
      bottomBorder: commonBorder,
      bold: false
    );

    // Cell update

    // Name cell
    sheetObject.updateCell(
      excel.CellIndex.indexByString('D3'), excel.TextCellValue(user.nome), cellStyle: headerStyle, // Prefissi qui
    );

    // Surname cell
    sheetObject.updateCell(
      excel.CellIndex.indexByString('F3'), excel.TextCellValue(user.cognome), cellStyle: headerStyle, // Prefissi qui
    );

    // Month cell
    final monthDate = DateTime(targetYear, targetMonth);
    final monthFormatter = DateFormat.MMMM('it_IT');
    final monthName = monthFormatter.format(monthDate);
    sheetObject.updateCell(
      excel.CellIndex.indexByString('E4'),
      excel.TextCellValue("${monthName.toSentenceCase()} $targetYear"),
      cellStyle: headerStyle, // Prefissi qui
    );

    // IBAN cell
    sheetObject.updateCell(
      excel.CellIndex.indexByString('E5'), excel.TextCellValue(user.iban), cellStyle: headerStyle, // Prefissi qui
    );

    // Signature cell
    sheetObject.updateCell(
      excel.CellIndex.indexByString('B49'), excel.TextCellValue('${user.nome} ${user.cognome}'), cellStyle: signatureStyle, // Prefissi qui
    );

    // Today cell
    sheetObject.updateCell(
      excel.CellIndex.indexByString('F49'), excel.DateCellValue.fromDateTime(DateTime.now()), cellStyle: headerStyle, // Prefisso qui
    );

    // Here we populate the shifts cells

    // Filtering the shifts that took place in the requested month (and year)
    List<Shift> filteredShifts = allShifts
      .where((shift) => shift.dtStart.month == targetMonth && shift.dtStart.year == targetYear)
      .toList();
    // Ordered by dtStart
    filteredShifts.sort((a, b) => a.dtStart.compareTo(b.dtStart));
    
    // This is where we start
    int startRowNumber = 8;

    // Cycling through all the shifts
    for (int i = 0; i < filteredShifts.length; i++) {
      final shift = filteredShifts[i];
      int currentRowNumber = startRowNumber + i;

      // Shift's date here
      sheetObject.updateCell(
        excel.CellIndex.indexByString('A$currentRowNumber'),
        excel.TextCellValue(shift.dtStart.toSlashDate()),
        cellStyle: baseStyle,
      );
      // Shift's classes here
      sheetObject.updateCell(
        excel.CellIndex.indexByString('B$currentRowNumber'),
        excel.IntCellValue((shift.dtStart.difference(shift.dtEnd).abs().inMinutes / 45).toInt()),
        cellStyle: baseStyle
      );
      // Shift's duration here
      sheetObject.updateCell(
        excel.CellIndex.indexByString('C$currentRowNumber'),
        excel.TextCellValue(shift.dtStart.difference(shift.dtEnd).abs().inMinutes.toString()),
        cellStyle: baseStyle
      );
      // Shift's name here
      sheetObject.updateCell(
        excel.CellIndex.indexByString('D$currentRowNumber'),
        excel.TextCellValue(shift.name.toSentenceCase()),
        cellStyle: baseStyle
      );
      // Shift's location here
      sheetObject.updateCell(
        excel.CellIndex.indexByString('E$currentRowNumber'),
        excel.TextCellValue(shift.name == "clarina" ? "Clarina" : "M. Bianca"),
        cellStyle: baseStyle
      );
    }
    // CELLS POPULATION COMPLETE

    // If there has been an error I return
    var fileBytes = excelDoc.encode();
    if (fileBytes == null) {
      return;
    }

    final Uint8List bytesToSave = Uint8List.fromList(fileBytes);
    String fileName =
      "${user.nome.toSentenceCase()}${user.cognome.toSentenceCase()}_${monthName.toSentenceCase()}_$targetYear.xlsx";

    await FilePicker.platform.saveFile(
      dialogTitle: "Salva il Modulo Mensile",
      fileName: fileName,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: bytesToSave,
      lockParentWindow: true,
    );
  } catch (e) {
    return;
  }
}