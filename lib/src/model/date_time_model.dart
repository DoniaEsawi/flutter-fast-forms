import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../form_style.dart';
import '../form_container.dart';
import '../widget/date-time-form-field.dart';

import 'form_field_model.dart';

@immutable
class DateTimeModel extends FormFieldModel<DateTime> {
  DateTimeModel({
    builder,
    decoration,
    helper,
    hint,
    id,
    DateTime initialValue,
    label,
    validator,
    @required this.firstDate,
    this.initialDatePickerMode,
    this.initialEntryMode,
    @required this.lastDate,
  }) : super(
          builder: builder ??
              (context, state) {
                final store =
                    Provider.of<FastFormStore>(context, listen: false);
                final styler = FormStyle.of(context);
                return DateTimeFormField(
                    decoration: decoration ??
                        styler.createInputDecoration(context, state.widget),
                    firstDate: firstDate,
                    lastDate: lastDate,
                    value: state.value,
                    validator: validator,
                    onSaved: (value) => store.setValue(id, value),
                    onChanged: state.save);
              },
          helper: helper,
          hint: hint,
          id: id,
          initialValue: initialValue,
          label: label,
          validator: validator,
        );

  final DateTime firstDate;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;

  @override
  State<StatefulWidget> createState() => FormFieldModelState<DateTime>();
}
