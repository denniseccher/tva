import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:loomeive/loomeive.dart';

class DurationPickerField extends FormBuilderField<Duration> {
  final InputDecoration decoration;

  DurationPickerField({
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

    this.decoration = const InputDecoration(),
  }) : super(
    builder: (FormFieldState<Duration?> field) {
      final widget = field.widget as DurationPickerField;
      final bool isEnabled = widget.enabled;

      final InputDecoration effectiveDecoration = widget.decoration
        .applyDefaults(Theme.of(field.context).inputDecorationTheme)
        .copyWith(
          errorText: field.errorText,
        );

      final String displayValue = field.value?.toHHmmSS() ?? '';

      return InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap:
          !isEnabled
            ? null
            : () async {
              FocusScope.of(field.context).unfocus();
              try {
                final Duration? result = await showDurationPicker(
                  context: field.context,
                  initialTime: field.value ?? Duration.zero,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16)
                  ),
                  
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
          isEmpty:
              field.value == null && effectiveDecoration.hintText == null,
          // isFocused: field.?.hasFocus ?? false,
          child: Text(
            textAlign: TextAlign.center,
            displayValue.isNotEmpty
                ? displayValue
                : (effectiveDecoration.hintText ?? ''),
            style:
              field.value == null
                ? effectiveDecoration.hintStyle
                : Theme.of(
                  field.context,
                ).textTheme.titleMedium?.copyWith(
                  color:
                    isEnabled
                      ? null
                      : Theme.of(field.context).disabledColor,
                ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
    },
  );
}
