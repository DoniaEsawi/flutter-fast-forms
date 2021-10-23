import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../form_field.dart';

typedef FastSliderFixBuilder = Widget Function(FastSliderState state);

typedef FastSliderLabelBuilder = String Function(FastSliderState state);

@immutable
class FastSlider extends FastFormField<double> {
  const FastSlider({
    bool? adaptive,
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<double>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    FocusNode? focusNode,
    String? helperText,
    required String id,
    double? initialValue,
    Key? key,
    String? label,
    ValueChanged<double>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<double>? onSaved,
    FormFieldValidator<double>? validator,
    this.divisions,
    this.errorBuilder,
    this.helperBuilder,
    this.max = 1.0,
    this.min = 0.0,
    this.labelBuilder,
    this.prefixBuilder,
    this.suffixBuilder,
  }) : super(
          adaptive: adaptive,
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? adaptiveSliderBuilder,
          contentPadding: contentPadding,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          id: id,
          initialValue: initialValue ?? min,
          key: key,
          label: label,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final int? divisions;
  final FastErrorBuilder<double>? errorBuilder;
  final FastHelperBuilder<double>? helperBuilder;
  final FastSliderLabelBuilder? labelBuilder;
  final double max;
  final double min;
  final FastSliderFixBuilder? prefixBuilder;
  final FastSliderFixBuilder? suffixBuilder;

  @override
  FastSliderState createState() => FastSliderState();
}

class FastSliderState extends FastFormFieldState<double> {
  @override
  FastSlider get widget => super.widget as FastSlider;
}

String sliderLabelBuilder(FastSliderState state) {
  return state.value!.toStringAsFixed(0);
}

SizedBox sliderSuffixBuilder(FastSliderState state) {
  return SizedBox(
    width: 32.0,
    child: Text(
      state.value!.toStringAsFixed(0),
      style: const TextStyle(
        fontSize: 16.0,
      ),
    ),
  );
}

InputDecorator sliderBuilder(FormFieldState<double> field) {
  final state = field as FastSliderState;
  final widget = state.widget;

  return InputDecorator(
    decoration: state.decoration.copyWith(
      contentPadding: widget.contentPadding,
      errorText: state.errorText,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(state),
        Expanded(
          child: Slider.adaptive(
            autofocus: widget.autofocus,
            divisions: widget.divisions,
            focusNode: state.focusNode,
            label: widget.labelBuilder?.call(state),
            max: widget.max,
            min: widget.min,
            value: state.value!,
            onChanged: widget.enabled ? state.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(state),
      ],
    ),
  );
}

CupertinoFormRow cupertinoSliderBuilder(FormFieldState<double> field) {
  final state = field as FastSliderState;
  final widget = state.widget;

  return CupertinoFormRow(
    padding: widget.contentPadding,
    prefix: widget.label is String ? Text(widget.label!) : null,
    helper: widget.helperBuilder?.call(state) ?? helperBuilder(state),
    error: widget.errorBuilder?.call(state) ?? errorBuilder(state),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        if (widget.prefixBuilder != null) widget.prefixBuilder!(state),
        Expanded(
          child: CupertinoSlider(
            divisions: widget.divisions,
            max: widget.max,
            min: widget.min,
            value: state.value!,
            onChanged: widget.enabled ? state.didChange : null,
          ),
        ),
        if (widget.suffixBuilder != null) widget.suffixBuilder!(state),
      ],
    ),
  );
}

Widget adaptiveSliderBuilder(FormFieldState<double> field) {
  final state = field as FastSliderState;

  if (state.adaptive) {
    switch (Theme.of(state.context).platform) {
      case TargetPlatform.iOS:
        return cupertinoSliderBuilder(field);
      case TargetPlatform.android:
      default:
        return sliderBuilder(field);
    }
  }
  return sliderBuilder(field);
}
