import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/utilities/extensions.utility.dart'; // Importa rootBundle

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


// --- FUNZIONE populateAndSaveReport CORRETTA ---
Future<void> populateAndSaveReport({
  required BuildContext context,
  required String assetPath,
  required User user,
  required List<Shift> allShifts,
  required int targetMonth,
  required int targetYear,
}) async {
  try {
    // 1. CARICAMENTO E ACCESSO AL FOGLIO
    if (kDebugMode) print('Caricamento template da: $assetPath');
    final ByteData data = await rootBundle.load(assetPath);
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    // Usa prefisso e rinomina variabile locale
    var excelDoc = excel.Excel.decodeBytes(bytes);

    if (excelDoc.tables.keys.isEmpty) {
       if (kDebugMode) print('Errore: Nessun foglio trovato nel file template.');
       return;
    }
    var sheetKey = excelDoc.tables.keys.first;
    // Usa prefisso
    var sheetObject = excelDoc.tables[sheetKey];
    if (sheetObject == null) {
      if (kDebugMode) print('Errore: Impossibile accedere al foglio "$sheetKey".');
      return;
    }
     if (kDebugMode) print('Utilizzo foglio: "$sheetKey"');


    // --- 3. DEFINIZIONE DEGLI STILI (Applica prefisso a tutti i tipi excel) ---

    var commonBorder = excel.Border( // Prefisso qui
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

    // --- 4. POPOLAMENTO CELLE SPECIFICHE (Applica prefisso a tutti i tipi excel) ---

    sheetObject.updateCell(
      excel.CellIndex.indexByString('D3'), excel.TextCellValue(user.nome), cellStyle: headerStyle, // Prefissi qui
    );

    sheetObject.updateCell(
       excel.CellIndex.indexByString('F3'), excel.TextCellValue(user.cognome), cellStyle: headerStyle, // Prefissi qui
    );

    final monthDate = DateTime(targetYear, targetMonth);
    final monthFormatter = DateFormat.MMMM('it_IT');
    final monthName = monthFormatter.format(monthDate);
    sheetObject.updateCell(
      excel.CellIndex.indexByString('E4'), excel.TextCellValue(monthName[0].toUpperCase() + monthName.substring(1)), cellStyle: headerStyle, // Prefissi qui
    );

    sheetObject.updateCell(
      excel.CellIndex.indexByString('E5'), excel.TextCellValue(user.iban), cellStyle: headerStyle, // Prefissi qui
    );

    // --- 5. FILTRA E POPOLA RIGHE TURNI (Applica prefisso a tutti i tipi excel) ---
    List<Shift> filteredShifts = allShifts
        .where((shift) => shift.dtStart.month == targetMonth && shift.dtStart.year == targetYear) // Assumo che Shift abbia dtStart
        .toList();
    filteredShifts.sort((a, b) => a.dtStart.compareTo(b.dtStart)); // Assumo dtStart

    int startRowNumber = 8;

    for (int i = 0; i < filteredShifts.length; i++) {
      final shift = filteredShifts[i];
      int currentRowNumber = startRowNumber + i;

      sheetObject.updateCell(
        excel.CellIndex.indexByString('A$currentRowNumber'), // Prefisso qui
        excel.TextCellValue(shift.dtStart.toSlashDate()), // Prefisso qui, assumo dtStart
        cellStyle: baseStyle,
      );

      sheetObject.updateCell(excel.CellIndex.indexByString('B$currentRowNumber'), excel.IntCellValue((shift.dtStart.difference(shift.dtEnd).abs().inMinutes / 45).toInt()), cellStyle: baseStyle); // Prefissi qui
      sheetObject.updateCell(excel.CellIndex.indexByString('C$currentRowNumber'), excel.TextCellValue(shift.dtStart.difference(shift.dtEnd).abs().inMinutes.toString()), cellStyle: baseStyle); // Prefissi qui
      sheetObject.updateCell(excel.CellIndex.indexByString('D$currentRowNumber'), excel.TextCellValue(shift.name), cellStyle: baseStyle); // Prefissi qui, assumo shift.name
      sheetObject.updateCell(excel.CellIndex.indexByString('E$currentRowNumber'), excel.TextCellValue(shift.name == "clarina" ? "Clarina" : "M. Bianca"), cellStyle: baseStyle); // Prefissi qui
    }

    // --- 6. POPOLA FOOTER (Applica prefisso a tutti i tipi excel) ---

    sheetObject.updateCell(
      excel.CellIndex.indexByString('B49'), excel.TextCellValue('${user.nome} ${user.cognome}'), cellStyle: signatureStyle, // Prefissi qui
    );

    sheetObject.updateCell(
      excel.CellIndex.indexByString('F49'), excel.DateCellValue.fromDateTime(DateTime.now()), cellStyle: headerStyle, // Prefisso qui
    );


    // --- 7. ENCODING E SALVATAGGIO ---
    if (kDebugMode) print('Encoding del file Excel...');
    // Usa la variabile rinominata excelDoc
    var fileBytes = excelDoc.encode();

    if (fileBytes == null) {
      if (kDebugMode) print('Errore: Encoding del file fallito.');
      return;
    }

    final Uint8List bytesToSave = Uint8List.fromList(fileBytes);
    String suggestedFileName = '${user.nome.toSentenceCase()}${user.cognome.toSentenceCase()}_${DateTime(targetYear, targetMonth).toLocaleMonthShort(context).toSentenceCase()}_$targetYear.xlsx';
    if (kDebugMode) print('Richiesta salvataggio file: $suggestedFileName');

    await FilePicker.platform.saveFile(
      dialogTitle: 'Salva il report mensile',
      fileName: suggestedFileName,
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      bytes: bytesToSave,
      lockParentWindow: true,
    );

     if (kDebugMode) print('Operazione di salvataggio completata.');

  } catch (e, stackTrace) {
     if (kDebugMode) {
       print('Errore durante la generazione o salvataggio del report Excel: $e');
       print('Stack Trace: $stackTrace');
     }
     // Gestione errore utente
  }
}