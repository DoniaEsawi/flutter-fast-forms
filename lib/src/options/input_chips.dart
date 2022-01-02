import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

import '../form_field.dart';

import 'autocomplete.dart';

typedef FastInputChipBuilder = Widget Function(
    String chip, FastInputChipsState field);

typedef FastInputChipTextFieldViewBuilder = Widget Function(
    VoidCallback onFieldSubmitted, FastInputChipsState field);

@immutable
class FastInputChips extends FastFormField<List<String>> {
  FastInputChips({
    bool autofocus = false,
    AutovalidateMode autovalidateMode = AutovalidateMode.onUserInteraction,
    FormFieldBuilder<List<String>>? builder,
    EdgeInsetsGeometry? contentPadding,
    InputDecoration? decoration,
    bool enabled = true,
    String? helperText,
    List<String>? initialValue,
    Key? key,
    String? label,
    required String name,
    ValueChanged<List<String>>? onChanged,
    VoidCallback? onReset,
    FormFieldSetter<List<String>>? onSaved,
    FormFieldValidator<List<String>>? validator,
    this.alignment = WrapAlignment.start,
    this.chipBuilder,
    this.clipBehavior = Clip.none,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    // this.direction = Axis.horizontal,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.fieldViewBuilder,
    this.onSelected,
    this.options = const [],
    this.optionsBuilder,
    this.optionsMatcher,
    this.optionsMaxHeight = 200.0,
    this.optionsViewBuilder,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.spacing = 8.0,
    this.textDirection,
    this.textFieldViewBuilder,
    this.textFieldViewMinWidth = 80.0,
    this.textFieldViewValidator,
    this.verticalDirection = VerticalDirection.down,
  }) : super(
          autofocus: autofocus,
          autovalidateMode: autovalidateMode,
          builder: builder ?? inputChipsBuilder,
          decoration: decoration,
          enabled: enabled,
          helperText: helperText,
          initialValue: initialValue ?? <String>[],
          key: key,
          label: label,
          name: name,
          onChanged: onChanged,
          onReset: onReset,
          onSaved: onSaved,
          validator: validator,
        );

  final WrapAlignment alignment;
  final FastInputChipBuilder? chipBuilder;
  final Clip clipBehavior;
  final WrapCrossAlignment crossAxisAlignment;

  // final Axis direction;
  final AutocompleteOptionToString<String> displayStringForOption;
  final FastAutocompleteFieldViewBuilder<String>? fieldViewBuilder;
  final AutocompleteOnSelected<String>? onSelected;
  final Iterable<String> options;
  final AutocompleteOptionsBuilder<String>? optionsBuilder;
  final FastOptionsMatcher<String>? optionsMatcher;
  final double optionsMaxHeight;
  final AutocompleteOptionsViewBuilder<String>? optionsViewBuilder;
  final WrapAlignment runAlignment;
  final double runSpacing;
  final double spacing;
  final TextDirection? textDirection;
  final FastInputChipTextFieldViewBuilder? textFieldViewBuilder;
  final FormFieldValidator<String>? textFieldViewValidator;
  final double textFieldViewMinWidth;
  final VerticalDirection verticalDirection;

  @override
  FastInputChipsState createState() => FastInputChipsState();
}

class FastInputChipsState extends FastFormFieldState<List<String>> {
  final textEditingController = TextEditingController();
  final textFocusNode = FocusNode();

  @override
  FastInputChips get widget => super.widget as FastInputChips;
}

Widget _chipBuilder(String chip, FastInputChipsState field) {
  return InputChip(
    label: Text(chip),
    isEnabled: field.widget.enabled,
    onDeleted: () => field.didChange([...field.value!]..remove(chip)),
  );
}

Widget _textFieldViewBuilder(FastInputChipsState field,
    Function(String) onFieldSubmitted, double freeSpace) {
  final minWidth = field.widget.textFieldViewMinWidth;
  final width = minWidth > freeSpace ? double.infinity : freeSpace;

  return SizedBox(
    width: width,
    child: TextFormField(
      controller: field.textEditingController,
      decoration: const InputDecoration(border: OutlineInputBorder()),
      enabled: field.widget.enabled,
      focusNode: field.textFocusNode,
      maxLines: 1,
      onFieldSubmitted: onFieldSubmitted,
      validator: field.widget.textFieldViewValidator,
    ),
  );
}

Widget _feedbackBuilder(String chip, FastInputChipsState _field) {
  return Material(
    type: MaterialType.transparency,
    child: InputChip(
      isEnabled: true,
      label: Text(chip),
      onDeleted: () {},
    ),
  );
}

typedef ChipDragTargetMove<T> = void Function(
    DragTargetDetails<T> details, String chip);

class FastDraggableInputChip extends StatelessWidget {
  const FastDraggableInputChip({
    Key? key,
    required this.chip,
    required this.field,
    required this.view,
    this.onAccept,
    this.onAcceptWithDetails,
    this.onAnimationEnd,
    this.onDragCompleted,
    this.onDragEnd,
    this.onDraggableCanceled,
    this.onDragStarted,
    this.onDragUpdate,
    this.onLeave,
    this.onMove,
    this.onWillAccept,
  }) : super(key: key);

  final String chip;
  final FastInputChipsState field;
  final DragTargetAccept<String>? onAccept;
  final DragTargetAcceptWithDetails<String>? onAcceptWithDetails;
  final VoidCallback? onAnimationEnd;
  final VoidCallback? onDragCompleted;
  final DragEndCallback? onDragEnd;
  final DraggableCanceledCallback? onDraggableCanceled;
  final VoidCallback? onDragStarted;
  final DragUpdateCallback? onDragUpdate;
  final DragTargetLeave<String>? onLeave;
  final ChipDragTargetMove<String>? onMove;
  final DragTargetWillAccept<String>? onWillAccept;
  final FastInputChipsViewState view;

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onAccept: onAccept,
      onAcceptWithDetails: onAcceptWithDetails,
      onLeave: onLeave,
      onMove: (details) => onMove?.call(details, chip),
      onWillAccept: onWillAccept,
      builder: (context, candidateItems, _rejectedItems) {
        // final isDropTarget = candidateItems.isNotEmpty;
        final chipBuilder = field.widget.chipBuilder ?? _chipBuilder;
        return Draggable<String>(
          onDragCompleted: onDragCompleted,
          onDraggableCanceled: onDraggableCanceled,
          onDragEnd: onDragEnd,
          onDragStarted: onDragStarted,
          onDragUpdate: onDragUpdate,
          data: chip,
          dragAnchorStrategy: childDragAnchorStrategy,
          maxSimultaneousDrags: 1,
          feedback: _feedbackBuilder(chip, field),
          childWhenDragging: const SizedBox.shrink(),
          child: chipBuilder(chip, field),
          /*
          child: AnimatedPadding(
            duration: Duration(milliseconds: view.dragX == null ? 0 : 200),
            padding: _getDragTargetPadding(isDropTarget),
            child: chipBuilder(chip, field),
          ),
          */
        );
      },
    );
  }
}

class FastInputChipsView extends StatefulWidget {
  const FastInputChipsView({
    Key? key,
    required this.field,
    required this.onFieldSubmitted,
  }) : super(key: key);

  final FastInputChipsState field;
  final VoidCallback onFieldSubmitted;

  @override
  FastInputChipsViewState createState() => FastInputChipsViewState();
}

class FastInputChipsViewState extends State<FastInputChipsView> {
  static const dragRL = -1;
  static const dragLR = 1;

  final wrapKey = GlobalKey();

  int? dragX;

  RenderWrap get renderWrap =>
      wrapKey.currentContext?.findRenderObject() as RenderWrap;

  FastDraggableInputChip _buildDraggableChip(String chip) {
    final field = widget.field;
    return FastDraggableInputChip(
      chip: chip,
      field: field,
      view: this,
      onAccept: (acceptChip) {
        final acceptIndex = field.value!.indexOf(acceptChip);
        final targetIndex = field.value!.indexOf(chip);
        int insertIndex = targetIndex;

        if (acceptIndex < targetIndex && dragX == dragRL) {
          //
        } else if (acceptIndex > targetIndex && dragX == dragLR) {
          //
        }
        widget.field.didChange([...field.value!]
          ..removeAt(acceptIndex)
          ..insert(insertIndex, acceptChip));
      },
      onDragEnd: (_details) {
        setState(() => dragX = null);
      },
      onDragUpdate: (details) {
        if (details.delta.dx != 0.0) {
          setState(() {
            dragX = details.delta.dx.round().clamp(dragRL, dragLR);
          });
        }
      },
    );
  }

  double _getFreeSpace() {
    final wrap = renderWrap;
    final wrapWidth =
        wrap.hasSize ? wrap.paintBounds.width : wrap.constraints.maxWidth;
    final boxes = wrap.getChildrenAsList()..removeLast();
    final runs = <List<RenderBox>>[];

    if (boxes.isEmpty) return wrapWidth;

    double runExtent = 0.0;

    for (final box in boxes) {
      final width = box.paintBounds.width + widget.field.widget.spacing;
      final isRunStart = box == boxes.first || runExtent + width > wrapWidth;

      if (isRunStart) {
        runs.add([box]);
        runExtent = width;
      } else {
        runs.last.add(box);
        runExtent = runExtent + width;
      }
    }

    return wrapWidth - runExtent;
  }

  @override
  Widget build(BuildContext context) {
    final field = widget.field;
    final chipBuilder = field.widget.chipBuilder ?? _chipBuilder;
    final textFieldViewBuilder =
        field.widget.textFieldViewBuilder ?? _textFieldViewBuilder;

    void onFieldSubmitted(String value) {
      if (value.isEmpty) {
        field.textFocusNode.unfocus();
      } else {
        widget.onFieldSubmitted();
        _addChip(value, field);
      }
    }

    return Wrap(
      key: wrapKey,
      alignment: field.widget.alignment,
      clipBehavior: field.widget.clipBehavior,
      crossAxisAlignment: field.widget.crossAxisAlignment,
      direction: Axis.horizontal,
      spacing: field.widget.spacing,
      runAlignment: field.widget.runAlignment,
      runSpacing: field.widget.runSpacing,
      textDirection: field.widget.textDirection,
      verticalDirection: field.widget.verticalDirection,
      children: [
        for (final chip in field.value!) chipBuilder(chip, field),
        LayoutBuilder(
          builder: (_context, _constraints) {
            final freeSpace = _getFreeSpace();
            return textFieldViewBuilder(field, onFieldSubmitted, freeSpace);
          },
        ),
      ],
    );
  }
}

bool _optionsMatcher(TextEditingValue value, String option) {
  return option.toLowerCase().contains(value.text.toLowerCase());
}

AutocompleteOptionsBuilder<String> _optionsBuilder(
    Iterable<String> options, FastInputChipsState field) {
  return (TextEditingValue value) {
    if (value.text.isEmpty) {
      return const Iterable.empty();
    }
    final optionsMatcher = field.widget.optionsMatcher ?? _optionsMatcher;
    return options.where((option) => optionsMatcher(value, option));
  };
}

AutocompleteFieldViewBuilder _fieldViewBuilder(FastInputChipsState field) {
  return (BuildContext context, TextEditingController textEditingController,
      FocusNode focusNode, VoidCallback onFieldSubmitted) {
    return FastInputChipsView(field: field, onFieldSubmitted: onFieldSubmitted);
  };
}

void _addChip(String? chip, FastInputChipsState field) {
  if (chip != null && !field.value!.contains(chip)) {
    field.didChange([...field.value!, chip]);
    field.textEditingController.clear();
    field.textFocusNode.requestFocus();
  }
}

AutocompleteOptionsViewBuilder<String> _optionsViewBuilder(
    FastInputChipsState field) {
  return (BuildContext context, AutocompleteOnSelected<String> onSelected,
      Iterable<String> options) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: field.widget.optionsMaxHeight),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final String option = options.elementAt(index);
              return InkWell(
                onTap: () => onSelected(option),
                child: Builder(builder: (BuildContext context) {
                  final bool highlight =
                      AutocompleteHighlightedOption.of(context) == index;
                  if (highlight) {
                    SchedulerBinding.instance!
                        .addPostFrameCallback((Duration timeStamp) {
                      Scrollable.ensureVisible(context, alignment: 0.5);
                    });
                  }
                  return Container(
                    color: highlight ? Theme.of(context).focusColor : null,
                    padding: const EdgeInsets.all(16.0),
                    child: Text(field.widget.displayStringForOption(option)),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  };
}

Widget inputChipsBuilder(FormFieldState<List<String>> field) {
  final _field = field as FastInputChipsState;
  final widget = _field.widget;

  return GestureDetector(
    onTap: widget.enabled ? () => _field.textFocusNode.requestFocus() : null,
    child: InputDecorator(
      decoration: _field.decoration.copyWith(
        contentPadding: widget.contentPadding,
        errorText: _field.errorText,
      ),
      child: RawAutocomplete<String>(
        displayStringForOption: widget.displayStringForOption,
        fieldViewBuilder: _fieldViewBuilder(_field),
        focusNode: _field.textFocusNode,
        onSelected: (String? value) => _addChip(value, _field),
        optionsBuilder: _optionsBuilder(widget.options, _field),
        optionsViewBuilder:
            widget.optionsViewBuilder ?? _optionsViewBuilder(_field),
        textEditingController: _field.textEditingController,
      ),
    ),
  );
}
