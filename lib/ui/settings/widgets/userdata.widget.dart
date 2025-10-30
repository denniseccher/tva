import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loomeive/loomeive.dart';

class UserDataWidget extends StatefulWidget {
  const UserDataWidget({super.key});

  @override
  State<UserDataWidget> createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  static final _formKey = GlobalKey<FormBuilderState>();
  bool _isFormDirty = false;
  late Future<Map<String, dynamic>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _isFormDirty = false;
    _dataFuture = loadUserData();
  }

  void _onFormChanged() {
    final isDirty = _formKey.currentState?.isDirty ?? false;

    if (_isFormDirty != isDirty) {
      setState(() {
        _isFormDirty = isDirty;
      });
    }
  }

  void _getClipboardText() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      _formKey.currentState?.patchValue({'iban': clipboardData?.text});
    }
  }

  // TODO qui vanno presi dal backend
  Future<Map<String, dynamic>> loadUserData() async {
    // Simula un ritardo di rete
    await Future.delayed(const Duration(seconds: 1));
    return const {
      'name': 'Dennis',
      'surname': 'Eccher',
      'iban': 'IT60X0542811101000000123456',
    };
  }

  // TODO qui vanno mandati i dati al backend
  void _saveForm() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      print("about to send ${_formKey.currentState?.value}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          spacing: 16,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.arrowLeft),
                ),
                Expanded(
                  child: Text(
                    tr('settings.user_data.title').toSmartSentenceCase,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
                FilledButton.tonal(
                  onPressed: _isFormDirty ? () => _saveForm() : null,
                  child: Text(tr("action.save").toSmartSentenceCase),
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  } else if (snapshot.hasData) {
                    return FormBuilder(
                      key: _formKey,
                      onChanged: _onFormChanged,
                      initialValue: snapshot.data!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 2,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  tr(
                                    'settings.user_data.name',
                                  ).toSmartSentenceCase,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              FormBuilderTextField(
                                name: 'name',
                                decoration: InputDecoration(
                                  hintText: 'descrizione',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  fillColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 2,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  tr(
                                    'settings.user_data.surname',
                                  ).toSmartSentenceCase,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              FormBuilderTextField(
                                name: 'surname',
                                decoration: InputDecoration(
                                  hintText: 'descrizione',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 2,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: Text(
                                  tr(
                                    'settings.user_data.iban',
                                  ).toSmartSentenceCase,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              FormBuilderTextField(
                                name: 'iban',
                                decoration: InputDecoration(
                                  suffixIconConstraints: BoxConstraints(
                                    maxWidth: double.infinity,
                                  ),
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: IconButton(
                                      tooltip:
                                          tr(
                                            'tooltip.paste_from_clipboard',
                                          ).toSmartSentenceCase,
                                      style: ButtonStyle(
                                        shape: WidgetStateProperty.all<
                                          RoundedRectangleBorder
                                        >(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.0,
                                            ), // 🔑 Raggio desiderato
                                          ),
                                        ),
                                      ),
                                      onPressed: () => _getClipboardText(),
                                      icon: Icon(LucideIcons.clipboardPaste),
                                    ),
                                  ),
                                  hintText: 'descrizione',
                                  hintStyle: TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
