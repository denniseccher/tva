import 'dart:io';

import 'package:excel/excel.dart' as excel;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:intl/intl.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:path_provider/path_provider.dart';

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
  required String type
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

    switch (type) {
      case "email":
        _sendEmailWithAttachment(
          bytesToSave,
          fileName,
          user,
          monthName
        );
        break;
      
      case "save":
        _saveFile(
          bytesToSave,
          fileName
        );
        break;
      default:
    }

    
  } catch (e) {
    return;
  }
}

Future _saveFile(Uint8List bytesToSave, String fileName) async {
  await FilePicker.platform.saveFile(
    dialogTitle: "Salva il Modulo Mensile",
    fileName: fileName,
    type: FileType.custom,
    allowedExtensions: ['xlsx'],
    bytes: bytesToSave,
    lockParentWindow: true,
  );
}

Future _sendEmailWithAttachment(Uint8List bytes, String fileName, User user, String monthName) async {
  final tempDir = await getTemporaryDirectory();
  final filePath = '${tempDir.path}/$fileName';
  final file = File(filePath);
  await file.writeAsBytes(bytes);

  final email = Email(
    body: "In allegato il modulo dei turni di ${monthName.toLowerCase()}",
    subject: "Turni $monthName, ${user.nome} ${user.cognome}",
    recipients: [],
    attachmentPaths: [filePath],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}