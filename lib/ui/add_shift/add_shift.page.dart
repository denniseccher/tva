import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/classes/shift.class.dart';
import 'package:miss_minutes/repositories/option.repository.dart';
import 'package:miss_minutes/utilities/extensions.utility.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';

class AddShiftPage extends StatelessWidget{
  AddShiftPage({super.key, required this.bloc, this.shift});

  final ShiftBloc bloc;
  final Shift? shift;

  final OptionRepository _optionRepository = OptionRepository();
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: bloc,
      child: FormBuilder(
        // Key del Form
        key: _formKey,
        // Valori iniziali, se esiste uno shift vuol dire che lo sto modificando quindi riempio con quelli
        initialValue: {
          'id' : shift?.id,
          'name' : shift?.name,
          'date' : shift?.dtStart ?? DateTime.now(),
          'timeStart' : shift?.dtStart,
          'timeEnd' : shift?.dtEnd
        },
        child: Padding(
          padding: EdgeInsets.only(
            bottom: kBottomNavigationBarHeight,
            left: 16,
            right: 16,
            top: 16
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              ListView(
                shrinkWrap: true,
                children: [
                  // Future builder per ottenere la lista di opzioni per il corso
                  FutureBuilder(
                    future: _optionRepository.getOptions(),
                    builder: (context, snapshot) {
                      return FormBuilderDropdown(
                        name: 'name',
                        hint: Text("--Nome del corso"),
                        // Stile
                        borderRadius: BorderRadius.circular(32),
                        alignment: Alignment.center,
                        decoration: InputDecoration(
                          filled: true,
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
                        // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required()
                        ]),
                        // È abilitato solo se i dati sono presenti, se non ci sono c'è una barra di caricamento
                        enabled: snapshot.hasData,
                        disabledHint: LinearProgressIndicator(),
                        // Le opzioni vengono dallo snapshot
                        items: snapshot.hasData ?
                          snapshot.data?.map(
                            (el) => DropdownMenuItem(
                              alignment: Alignment.center,
                              value: el.value,
                              child: Text(el.label?.toSentenceCase() ?? ''),
                            )
                          ).toList() ?? []
                        : [],
                      );
                    }
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
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.w500
                      ),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(32)
                      ),
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                    // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required()
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
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32)
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                          // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required()
                          ]),
                        ),
                      ),
              
                      Expanded(
                        // Qui viene scelta l'ora di fine
                        child: FormBuilderDateTimePicker(
                          name: 'timeEnd',
                          inputType: InputType.time,
                          initialTime: TimeOfDay(hour: 16, minute: 0),
                          locale: Locale('it'),
                          format: DateFormat('HH:mm', 'it'),
                          // Stile
                          decoration: InputDecoration(
                            hintText: '--Fine',
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500
                            ),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(32)
                            ),
                          ),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w600
                          ),
                          // La validazione viene fatta dopo un'intereazione dell'utente e richiede che sia presente un valore
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required()
                          ]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Pulsante di salvataggio e annulla
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32.0
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    // Pulsante di annullamento
                    Expanded(
                      child: FilledButton.tonal(
                        style: ButtonStyle(
                          fixedSize: WidgetStatePropertyAll(
                            Size(double.infinity, 48)
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
                            Size(double.infinity, 48)
                          )
                        ),
                        // Quando lo premo controllo che il form sia valido e lo salvo, poi eseguo la funzione per aggiungerlo
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          if(_formKey.currentState!.saveAndValidate()){
                            Map<String, dynamic> formValues = _formKey.currentState?.value ?? {};
                      
                            addShift(formValues: formValues, bloc: bloc, id: shift?.id);
                        
                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Salva"),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  
}