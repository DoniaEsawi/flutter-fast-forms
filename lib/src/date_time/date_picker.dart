import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../form_field.dart';

typedef FastDatePickerTextBuilder = Text Function(FastDatePickerState field);

typedef FastDatePickerModalPopupBuilder = Widget Function(
    BuildContext context, FastDatePickerState field);

typedef ShowFastDatePicker = Future<DateTime?> Function(
    DatePickerEntryMode entryMode);

typedef FastDatePickerIconButtonBuilder = IconButton Function(
    FastDatePickerState field, ShowFastDatePicker show);

@immutable
class FastDatePicker extends FastFormField<DateTime> {
  FastDatePicker({
    bool? adaptive,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<DateTime>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    DateTime? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<DateTime>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<DateTime>? onSaved,
    FormFieldValidator<DateTime>? validator,
    this.cancelText,
    this.confirmText,
    this.currentDate,
    this.dateFormat,
    this.errorBuilder,
    this.errorFormatText,
    this.errorInvalidText,
    this.fieldHintText,
    this.fieldLabelText,
    required this.firstDate,
    this.helperBuilder,
    this.height = 216.0,
    this.helpText,
    this.icon,
    this.iconButtonBuilder,
    this.initialDatePickerMode = DatePickerMode.day,
    this.initialEntryMode = DatePickerEntryMode.calendar,
    required this.lastDate,
    this.locale,
    this.maximumYear,
    this.minimumYear = 1,
    this.minuteInterval = 1,
    this.modalCancelButtonText = 'Cancel',
    this.modalDoneButtonText = 'Done',
    this.mode = CupertinoDatePickerMode.date,
    this.routeSettings,
    this.selectableDayPredicate,
    this.showModalPopup = false,
    this.textBuilder,
    this.use24hFormat = false,
    this.useRootNavigator = true,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? datePickerBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue ?? DateTime.now(),
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final String? cancelText;
  final String? confirmText;
  final DateTime? currentDate;
  final DateFormat? dateFormat;
  final FastErrorBuilder<DateTime>? errorBuilder;
  final String? errorFormatText;
  final String? errorInvalidText;
  final String? fieldHintText;
  final String? fieldLabelText;
  final DateTime firstDate;
  final double height;
  final FastHelperBuilder<DateTime>? helperBuilder;
  final String? helpText;
  final Icon? icon;
  final FastDatePickerIconButtonBuilder? iconButtonBuilder;
  final DatePickerMode initialDatePickerMode;
  final DatePickerEntryMode initialEntryMode;
  final DateTime lastDate;
  final Locale? locale;
  final int? maximumYear;
  final int minimumYear;
  final int minuteInterval;
  final String modalCancelButtonText;
  final String modalDoneButtonText;
  final CupertinoDatePickerMode mode;
  final RouteSettings? routeSettings;
  final SelectableDayPredicate? selectableDayPredicate;
  final bool showModalPopup;
  final FastDatePickerTextBuilder? textBuilder;
  final bool use24hFormat;
  final bool useRootNavigator;

  @override
  FastDatePickerState createState() => FastDatePickerState();
}

DateFormat _datePickerFormat(FastDatePickerState field) {
  final widget = field.widget;
  final locale = widget.locale;

  switch (widget.mode) {
    case CupertinoDatePickerMode.dateAndTime:
      final format = DateFormat.yMMMMEEEEd(locale);
      return widget.use24hFormat ? format.add_Hm() : format.add_jm();
    case CupertinoDatePickerMode.time:
      final format = widget.use24hFormat ? DateFormat.Hm : DateFormat.jm;
      return format(locale);
    case CupertinoDatePickerMode.date:
    default:
      return DateFormat.yMMMMEEEEd(locale);
  }
}

class FastDatePickerState extends FastFormFieldState<DateTime> {
  @override
  FastDatePicker get widget => super.widget as FastDatePicker;
}

Text datePickerTextBuilder(FastDatePickerState field) {
  final theme = Theme.of(field.context);
  final format =
      field.widget.dateFormat?.format ?? _datePickerFormat(field).format;
  final value = field.value;

  return Text(
    value != null ? format(field.value!) : '',
    style: theme.textTheme.subtitle1,
    textAlign: TextAlign.left,
  );
}

IconButton datePickerIconButtonBuilder(
    FastDatePickerState field, ShowFastDatePicker show) {
  final widget = field.widget;

  return IconButton(
    alignment: Alignment.center,
    icon: widget.icon ?? const Icon(Icons.today),
    onPressed: widget.enabled ? () => show(widget.initialEntryMode) : null,
  );
}

Container cupertinoDatePickerModalPopupBuilder(
    BuildContext context, FastDatePickerState field) {
  final widget = field.widget;
  DateTime? modalValue = field.value;

  return Container(
    color: CupertinoColors.systemBackground,
    height: widget.height + 90.0,
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CupertinoButton(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 16.0, 16.0),
              child: Text(widget.modalCancelButtonText),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            CupertinoButton(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 24.0, 16.0),
              child: Text(
                widget.modalDoneButtonText,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(modalValue),
            ),
          ],
        ),
        const Divider(
          height: 1.0,
          thickness: 1.0,
        ),
        Container(
          padding: const EdgeInsets.only(top: 6.0),
          height: widget.height,
          child: CupertinoDatePicker(
            initialDateTime: field.value,
            maximumDate: widget.lastDate,
            maximumYear: widget.maximumYear,
            minimumDate: widget.firstDate,
            minimumYear: widget.minimumYear,
            minuteInterval: widget.minuteInterval,
            mode: widget.mode,
            onDateTimeChanged: (DateTime value) => modalValue = value,
            use24hFormat: widget.use24hFormat,
          ),
        ),
      ],
    ),
  );
}

InkWell materialDatePickerBuilder(FormFieldState<DateTime> field) {
  final widget = (field as FastDatePickerState).widget;

  Future<DateTime?> show(DatePickerEntryMode entryMode) {
    return showDatePicker(
      cancelText: widget.cancelText,
      confirmText: widget.confirmText,
      context: field.context,
      currentDate: widget.currentDate,
      errorFormatText: widget.errorFormatText,
      errorInvalidText: widget.errorInvalidText,
      fieldHintText: widget.fieldHintText,
      fieldLabelText: widget.fieldLabelText,
      helpText: widget.helpText,
      initialDatePickerMode: widget.initialDatePickerMode,
      initialEntryMode: entryMode,
      initialDate: widget.initialValue ?? DateTime.now(),
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      locale: widget.locale,
      routeSettings: widget.routeSettings,
      selectableDayPredicate: widget.selectableDayPredicate,
      useRootNavigator: widget.useRootNavigator,
    ).then((value) {
      if (value != null) field.didChange(value);
      return value;
    });
  }

  final textBuilder = widget.textBuilder ?? datePickerTextBuilder;
  final iconButtonBuilder =
      widget.iconButtonBuilder ?? datePickerIconButtonBuilder;

  return InkWell(
    onTap: widget.enabled ? () => show(DatePickerEntryMode.input) : null,
    child: InputDecorator(
      decoration: field.decoration.copyWith(
        contentPadding: widget.contentPadding,
        errorText: field.errorText,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: textBuilder(field),
          ),
          iconButtonBuilder(field, show),
        ],
      ),
    ),
  );
}

CupertinoFormRow cupertinoDatePickerBuilder(FormFieldState<DateTime> field) {
  final widget = (field as FastDatePickerState).widget;
  final CupertinoThemeData themeData = CupertinoTheme.of(field.context);
  final TextStyle textStyle = themeData.textTheme.textStyle;
  final textBuilder = widget.textBuilder ?? datePickerTextBuilder;

  final text = Align(
    alignment: AlignmentDirectional.centerEnd,
    child: Padding(
      padding: const EdgeInsets.all(6.0),
      child: textBuilder(field),
    ),
  );

  return CupertinoFormRow(
    padding: widget.contentPadding,
    helper: (widget.helperBuilder ?? helperBuilder)(field),
    error: (widget.errorBuilder ?? errorBuilder)(field),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.label != null)
              DefaultTextStyle(
                style: textStyle,
                child: Text(widget.label!),
              ),
            Flexible(
              child: widget.showModalPopup
                  ? CupertinoButton(
                      padding: EdgeInsets.zero,
                      child: text,
                      onPressed: () {
                        showCupertinoModalPopup<DateTime>(
                          context: field.context,
                          builder: (BuildContext context) =>
                              cupertinoDatePickerModalPopupBuilder(
                                  context, field),
                        ).then((DateTime? value) {
                          if (value != null) field.didChange(value);
                        });
                      },
                    )
                  : text,
            ),
          ],
        ),
        if (!widget.showModalPopup)
          SizedBox(
            height: widget.height,
            child: CupertinoDatePicker(
              initialDateTime: widget.initialValue,
              maximumDate: widget.lastDate,
              maximumYear: widget.maximumYear,
              minimumDate: widget.firstDate,
              minimumYear: widget.minimumYear,
              minuteInterval: widget.minuteInterval,
              mode: widget.mode,
              onDateTimeChanged: field.didChange,
              use24hFormat: widget.use24hFormat,
            ),
          ),
      ],
    ),
  );
}

Widget datePickerBuilder(FormFieldState<DateTime> field) {
  FormFieldBuilder<DateTime> builder = materialDatePickerBuilder;

  if ((field as FastDatePickerState).adaptive) {
    final platform = Theme.of(field.context).platform;
    if (platform == TargetPlatform.iOS) builder = cupertinoDatePickerBuilder;
  }

  return builder(field);
}
