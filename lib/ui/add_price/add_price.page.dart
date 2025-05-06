import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class AddPricePage extends StatefulWidget{
  const AddPricePage({super.key});

  @override
  State<AddPricePage> createState() => _AddPricePageState();
}

class _AddPricePageState extends State<AddPricePage> {
  final _formKey = GlobalKey<FormBuilderState>();

  // Lista per tenere traccia delle chiavi univoche delle righe presenti nel form.
  // Usiamo timestamp o ID univoci per evitare problemi con gli indici quando si rimuovono elementi.
  // Inizializziamo con una riga.
  List<int> _tariffKeys = [DateTime.now().millisecondsSinceEpoch];

  // Funzione per costruire una singola riga del form
  Widget _buildTariffRow(int key, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Allinea i campi se l'errore li espande
        children: [
          Expanded(
            flex: 2, // Più spazio per la durata
            child: FormBuilderTextField(
              // Nome univoco basato sulla chiave e sul tipo di campo
              name: 'durata_$key',
              decoration: InputDecoration(
                labelText: 'Durata ${index + 1}', // Label user-friendly
                hintText: 'Es. 30 (giorni)',
              ),
              keyboardType: TextInputType.number,
              // Validazione: campo obbligatorio e numerico
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Obbligatorio'),
                FormBuilderValidators.numeric(errorText: 'Inserire un numero'),
                FormBuilderValidators.min(1, errorText: 'Deve essere > 0'),
              ]),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2, // Più spazio per il prezzo
            child: FormBuilderTextField(
              // Nome univoco
              name: 'prezzo_$key',
              decoration: InputDecoration(
                labelText: 'Prezzo ${index + 1}',
                hintText: 'Es. 9.99',
                suffixText: '€', // Aggiunge il simbolo dell'euro
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
               // Validazione: obbligatorio e numerico (può essere decimale)
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(errorText: 'Obbligatorio'),
                FormBuilderValidators.numeric(errorText: 'Inserire un numero'),
                FormBuilderValidators.min(0, errorText: 'Non può essere negativo'),
              ]),
              // Opzionale: trasforma il valore in double
              valueTransformer: (text) => text == null || text.isEmpty
                  ? null
                  : double.tryParse(text.replaceFirst(',', '.')), // Gestisce la virgola
            ),
          ),
          const SizedBox(width: 5),
          // Pulsante per rimuovere la riga, visibile solo se c'è più di una riga
          if (_tariffKeys.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 8.0), // Allinea verticalmente
              child: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Rimuovi riga',
                onPressed: () {
                  // Rimuovi i campi associati a questa chiave dallo stato del form
                  _formKey.currentState?.removeInternalFieldValue('durata_$key');
                  _formKey.currentState?.removeInternalFieldValue('prezzo_$key');

                  // Rimuovi la chiave dalla lista e aggiorna l'UI
                  setState(() {
                    _tariffKeys.remove(key);
                  });
                },
              ),
            )
          else
            // Spaziatore per mantenere l'allineamento quando c'è solo una riga
            const SizedBox(width: 48), // Larghezza standard di IconButton
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tariffe Dinamiche'),
      ),
      body: SingleChildScrollView( // Permette lo scroll se il form diventa lungo
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              FormBuilder(
                key: _formKey,
                // autovalidateMode: AutovalidateMode.onUserInteraction, // Valida mentre l'utente digita
                child: Column(
                  // Genera le righe basandosi sulle chiavi presenti in _tariffKeys
                  children: _tariffKeys.map((key) {
                     final index = _tariffKeys.indexOf(key); // Trova l'indice per il label
                     return _buildTariffRow(key, index);
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              // Pulsante per aggiungere una nuova riga
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Aggiungi Tariffa'),
                onPressed: () {
                  setState(() {
                    // Aggiunge una nuova chiave univoca alla lista
                    _tariffKeys.add(DateTime.now().millisecondsSinceEpoch);
                  });
                },
              ),
              const SizedBox(height: 30),
              // Pulsante per salvare e validare il form
              ElevatedButton(
                child: const Text('Salva Tariffe'),
                onPressed: () {
                  // Prima valida il form
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    // Se valido, recupera i dati
                    final formData = _formKey.currentState!.value;
                    final List<Map<String, dynamic>> tariffeList = [];

                    // Itera sulle chiavi attuali per estrarre i dati correttamente
                    for (final key in _tariffKeys) {
                      final durata = formData['durata_$key'];
                      final prezzo = formData['prezzo_$key']; // Già trasformato in double se valueTransformer è usato

                       // Potresti voler fare ulteriori parsing o controlli qui
                      if (durata != null && prezzo != null) {
                           tariffeList.add({
                             'durata': int.tryParse(durata) ?? 0, // Converte la durata in int
                             'prezzo': prezzo // Già double o null
                           });
                      }
                    }

                    // Ora hai la lista `tariffeList` pronta per essere usata
                    // print('Dati del form validi:');
                    // print(tariffeList);

                    // Mostra un feedback all'utente
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Tariffe salvate: ${tariffeList.length} elementi.'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    // Se non valido, mostra un messaggio di errore
                    // print('Validazione fallita');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Per favore, correggi gli errori nel form.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}