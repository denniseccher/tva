import 'package:duration_picker/duration_picker.dart'; // Assicura che questo import fornisca showDurationPicker
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart'; // Non sembra usata
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:loomeive/loomeive.dart';

class DurationPickerField extends FormBuilderField<Duration> {
  final InputDecoration decoration;

  DurationPickerField({
    // Parametri standard di FormBuilderField passati a super
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled = true,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onSaved,
    super.onReset,
    super.focusNode,

    // *** CORREZIONE 2: Inizializza il membro 'decoration' qui ***
    this.decoration = const InputDecoration(),

  }) : super(
          // La chiamata a super NON include 'decoration'
          builder: (FormFieldState<Duration?> field) {
            // Per accedere a 'decoration', usa field.widget
            // È utile fare un cast per chiarezza e accesso diretto
            final widget = field.widget as DurationPickerField;
            final bool isEnabled = widget.enabled;

            // *** CORREZIONE 3: Accedi a decoration tramite 'widget.decoration' ***
            final InputDecoration effectiveDecoration = widget.decoration
                .applyDefaults(Theme.of(field.context).inputDecorationTheme)
                .copyWith(
                  errorText: field.errorText,
                  // Anche qui usa widget.decoration per controllare se suffixIcon è già impostato
                  // suffixIcon: widget.decoration.suffixIcon ?? (isEnabled ? const Icon(Icons.timer_outlined, size: 18,) : null),
                );

            final String displayValue = field.value?.toHHmmSS() ?? '';

            return InkWell(
              onTap: !isEnabled
                  ? null
                  : () async {
                      FocusScope.of(field.context).unfocus();
                      try {
                        final Duration? result = await showDurationPicker(
                          context: field.context,
                          initialTime: field.value ?? Duration.zero,
                        );
                        if (result != null) {
                          field.didChange(result);
                        }
                      } catch (e) {
                        debugPrint("Errore durante showDurationPicker: $e");
                      }
                    },
              child: InputDecorator(
                decoration: effectiveDecoration,
                isEmpty: field.value == null && effectiveDecoration.hintText == null,
                // isFocused: field.?.hasFocus ?? false,
                child: Text(
                  textAlign: TextAlign.center,
                  displayValue.isNotEmpty
                      ? displayValue
                      : (effectiveDecoration.hintText ?? ''),
                  style: field.value == null
                      ? effectiveDecoration.hintStyle
                      : Theme.of(field.context).textTheme.titleMedium?.copyWith(
                          color: isEnabled ? null : Theme.of(field.context).disabledColor,
                        ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            );
          },
        );
}