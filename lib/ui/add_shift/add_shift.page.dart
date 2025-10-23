import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/repositories/course.repository.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';
import 'dart:math';

class AddShiftPage extends StatefulWidget {
  const AddShiftPage({super.key, required this.bloc, this.shift});

  final ShiftBloc bloc;
  final Shift? shift;

  @override
  State<AddShiftPage> createState() => _AddShiftPageState();
}

class _AddShiftPageState extends State<AddShiftPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  final CourseRepository _courseRepository = CourseRepository();

  @override
  void initState() {
    super.initState();

    printCourses();
  }

  printCourses() async {
    // print(
    //   await _courseRepository.getCourses().then(
    //     (courses) => courses.map(
    //       (course) => course
    //     )
    //   )
    // );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.bloc,
      child: FormBuilder(
        // Key del Form
        key: _formKey,
        // Valori iniziali, se esiste uno shift vuol dire che lo sto modificando quindi riempio con quelli
        initialValue: {
          'id': widget.shift?.id,
          // 'course' : widget.shift?.course,
          'date': widget.shift?.dtStart ?? DateTime.now(),
          'timeStart': widget.shift?.dtStart,
          'timeEnd': widget.shift?.dtEnd,
          'description': widget.shift?.description,
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: max(
              kBottomNavigationBarHeight,
              MediaQuery.of(context).viewInsets.bottom,
            ),
            left: 16,
            right: 16,
            top: 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  // Future builder per ottenere la lista di opzioni per il corso
                  FutureBuilder(
                    future: _courseRepository.getCourses(),
                    builder: (context, snapshot) {
                      return FormBuilderDropdown(
                        name: 'course',
                        hint: Text("--Nome del corso"),
                        // Stile
                        borderRadius: BorderRadius.circular(32),
                        alignment: Alignment.center,
                        decoration: InputDecoration(
                          filled: true,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(32),
                          ),
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(),
                        ]),
                        // È abilitato solo se i dati sono presenti, se non ci sono c'è una barra di caricamento
                        enabled: snapshot.hasData,
                        disabledHint: LinearProgressIndicator(),
                        initialValue:
                            (snapshot.data?.contains(widget.shift?.course) ??
                                    false)
                                ? widget.shift?.course
                                : null,
                        // Le opzioni vengono dallo snapshot
                        items:
                            snapshot.hasData
                                ? snapshot.data
                                        ?.map(
                                          (el) => DropdownMenuItem(
                                            alignment: Alignment.center,
                                            value: el,
                                            child: Text(
                                              "${el.name.toCapitalizeWord} - ${el.location.toCapitalizeWord}",
                                            ),
                                          ),
                                        )
                                        .toList() ??
                                    []
                                : [],
                      );
                    },
                  ),

                  Gap(8),

                  // Qui viene scelta la data, di default (se non c'è già uno shift) viene messa a oggi
                  FormBuilderDateTimePicker(
                    name: 'date',
                    inputType: InputType.date,
                    initialDate: DateTime.now(),
                    locale: Locale('it'),
                    format: DateFormat('d MMMM', 'it'),
                    // Stile
                    decoration: InputDecoration(
                      hintText: '--Inizio',
                      hintStyle: TextStyle(fontWeight: FontWeight.w500),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w600),
                    // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                    ]),
                  ),

                  Gap(8),

                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        // Qui viene scelta l'ora di inizio
                        child: FormBuilderDateTimePicker(
                          name: 'timeStart',
                          inputType: InputType.time,
                          initialTime: TimeOfDay(hour: 16, minute: 0),
                          locale: Locale('it'),
                          format: DateFormat('HH:mm', 'it'),
                          // Stile
                          decoration: InputDecoration(
                            hintText: '--Inizio',
                            hintStyle: TextStyle(fontWeight: FontWeight.w500),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600),
                          // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChanged: (value) {
                            if (value != null &&
                                (_formKey.currentState?.instantValue['timeEnd']
                                        as DateTime)
                                    .isBefore(value)) {
                              _formKey.currentState?.patchValue({
                                "timeEnd": null,
                              });
                            }
                          },
                        ),
                      ),

                      Expanded(
                        // Qui viene scelta l'ora di fine
                        child: FormBuilderDateTimePicker(
                          name: 'timeEnd',
                          inputType: InputType.time,
                          initialTime: TimeOfDay.fromDateTime(
                            DateTime.now().closest(
                              TimeStep.quarterHour,
                              round: Round.down,
                            ),
                          ),
                          locale: Locale('it'),
                          format: DateFormat('HH:mm', 'it'),
                          // Stile
                          decoration: InputDecoration(
                            hintText: '--Fine',
                            hintStyle: TextStyle(fontWeight: FontWeight.w500),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32),
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w600),
                          // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(),
                          ]),
                          onChanged: (value) {
                            print(
                              "TimeStart: ${_formKey.currentState?.instantValue['timeStart']}",
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(8),

                  FormBuilderTextField(
                    name: 'description',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    minLines: 1,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    decoration: InputDecoration(
                      hintText: 'descrizione',
                      hintStyle: TextStyle(fontWeight: FontWeight.w500),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(16),
              // Pulsante di salvataggio e annulla
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Row(
                  spacing: 8,
                  children: [
                    // Pulsante di annullamento
                    Expanded(
                      child: FilledButton.tonal(
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size(double.infinity, 48),
                          ),
                        ),
                        // Chiude quando viene premuto, annullando le modifiche
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).pop();
                        },
                        child: Text("Annulla"),
                      ),
                    ),
                    // Pulsante di salvataggio
                    Expanded(
                      child: FilledButton(
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size(double.infinity, 48),
                          ),
                        ),
                        // Quando lo premo controllo che il form sia valido e lo salvo, poi eseguo la funzione per aggiungerlo
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          if (_formKey.currentState!.saveAndValidate()) {
                            Map<String, dynamic> formValues =
                                _formKey.currentState?.value ?? {};

                            addShift(
                              formValues: formValues,
                              bloc: widget.bloc,
                              id: widget.shift?.id,
                            );

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Salva"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
