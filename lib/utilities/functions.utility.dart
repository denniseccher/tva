import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/bloc/shifts/shifts.state.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/utilities/xcl.dart' as xcl;
import 'package:miss_minutes/bloc/shifts/shifts.event.dart';

openSheet({ required BuildContext context, required ShiftBloc bloc, required String type}){
  ShiftsState state = bloc.state;
  List<DateTime> months = state is ShiftLoaded ? getUniqueMonthYearListFromShifts(state.shifts) : [];
  final formKey = GlobalKey<FormBuilderState>();
  final DateFormat formatter = DateFormat('MMMM yyyy', 'it_IT');

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32)
      )
    ),
    showDragHandle: true,
    builder: (context) {
      return FormBuilder(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: kTextTabBarHeight
          ),
          shrinkWrap: true,
          children: [
            Row(
              spacing: 8,
              children: [
                Expanded(
                  flex: 3,
                  child: FormBuilderDropdown(
                    name: 'month',
                    alignment: Alignment.center,
                    borderRadius: BorderRadius.circular(32),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      
                    ),
                    initialValue: months.last,
                    items: months.map(
                      (month) => DropdownMenuItem(
                        value: month,
                        alignment: Alignment.center,
                        child: Text(
                          formatter.format(month).toSentenceCase()
                        ),
                      )
                    ).toList()
                  )
                ),
                Expanded(
                  flex: 1,
                  child: FormBuilderTextField(
                    enabled: false,
                    name: 'extension',
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.primaryContainer,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                      
                    ),
                    textAlign: TextAlign.center,
                    initialValue: '.XLSX',
                  )
                ),
              ],
            ),
            Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0
              ),
              child: FilledButton.icon(
                style: ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(
                    Size(double.infinity, 48)
                  )
                ),
                icon: Icon(
                  switch(type){
                    "email" => Icons.send_rounded,
                    "save" => Icons.save_alt_rounded,
                    String() => null,
                  }
                ),
                label: Text(
                  switch(type){
                    "email" => "Invia email",
                    "save" => "Salva file",
                    String() => ""
                  }
                ),
                onPressed: () {
                  if(formKey.currentState?.saveAndValidate() ?? false){
                    xcl.populateAndSaveReport(
                      context: context,
                      user: xcl.User(nome: "Dennis", cognome: "Eccher", iban: "IABN"),
                      allShifts: (state is ShiftLoaded) ? state.shifts : [],
                      targetMonth: (formKey.currentState?.value['month'] as DateTime).month,
                      targetYear: (formKey.currentState?.value['month'] as DateTime).year,
                      type: type
                    );
                  }
                  // writeAndRequestDownloadExcel(context: context, month: 'Marzo 2025');
                },
              ),
            )
          ],
        )
      );
    },
  );
}

List<DateTime> getUniqueMonthYearListFromShifts(List<Shift> shifts) {
  if (shifts.isEmpty) {
    return [];
  }

  // Usa un Set per collezionare le date del primo giorno di ogni mese unico
  // Questo rende più facile l'ordinamento cronologico
  final Set<DateTime> uniqueFirstDayOfMonth = {};

  for (final shift in shifts) {
    // Crea un DateTime che rappresenta il primo giorno del mese/anno di dtStart
    final firstDay = DateTime(shift.dtStart.year, shift.dtStart.month, 1);
    uniqueFirstDayOfMonth.add(firstDay);
  }

  // Converti il Set in una Lista per poterla ordinare
  final List<DateTime> sortedMonths = uniqueFirstDayOfMonth.toList();

  // Ordina la lista di date cronologicamente (DateTime si ordina correttamente)
  sortedMonths.sort();

  // Formatta le date ordinate nella stringa "Mese Anno" in italiano
  // final DateFormat formatter = DateFormat('MMMM yyyy', 'it_IT'); // 'MMMM' per il nome completo del mese
  // final List<String> formattedMonthYearList = sortedMonths
  //   .map((date) => formatter.format(date))
  //   .toList();
  
  // return formattedMonthYearList;

  return sortedMonths;
}

double count(String month, List<Shift> shifts){
  double rtn = 0;

  for(Shift e in shifts.where((el) => el.dtStart.month == DateFormat.yMMMM('it').parse(month).month && el.dtStart.year == DateFormat.yMMMM('it').parse(month).year)){
    rtn += e.earning;
  }

  return rtn;
}
  
/// Function to add a shift
/// 
/// It composes a new Shift object and calls the right method (update or add)
void addShift({ required Map<String, dynamic> formValues, required ShiftBloc bloc, String? id }){
  DateTime dtStart = DateTime(
    (formValues['date'] as DateTime).year,
    (formValues['date'] as DateTime).month,
    (formValues['date'] as DateTime).day,
    (formValues['timeStart'] as DateTime).hour,
    (formValues['timeStart'] as DateTime).minute
  );

  DateTime dtEnd = DateTime(
    (formValues['date'] as DateTime).year,
    (formValues['date'] as DateTime).month,
    (formValues['date'] as DateTime).day,
    (formValues['timeEnd'] as DateTime).hour,
    (formValues['timeEnd'] as DateTime).minute
  );

  Shift newShift = Shift(
    id ?? '',
    name: formValues['name'],
    dtStart: dtStart,
    dtEnd: dtEnd,
    earning: prezzario.containsKey(
      dtStart.difference(dtEnd).abs()
    ) ? prezzario.entries.where(
      (el) => el.key == dtStart.difference(dtEnd).abs()
    ).first.value : 0.0,
    uid: FirebaseAuth.instance.currentUser?.uid ?? ''
  );

  bloc.add(
    newShift.id != '' ? UpdateShift(newShift: newShift) : AddShift(newShift) 
  );
}
