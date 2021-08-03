import 'package:flutter/material.dart';
import 'package:select_dialog/select_dialog.dart';

class ButtonSelect<SelectableType> extends StatefulWidget {
  ButtonSelect(
      {required void Function(SelectableType?) onSaved,
      required Widget Function(BuildContext, SelectableType?, bool) itemBuilder,
      required Widget Function(SelectableType?) displayItemBuilder,
      required String Function(SelectableType?) buttonText,
      String? Function(SelectableType?)? validator,
      required List<SelectableType> values,
      required String selectionLabel,
      SelectableType? initial,
      bool nullable = false,
      Key? key})
      : _onSaved = onSaved,
        _initial = initial,
        _itemBuilder = itemBuilder,
        _displayItemBuilder = displayItemBuilder,
        _buttonText = buttonText,
        _validator = validator,
        _values = values,
        _selectionLabel = selectionLabel,
        _nullable = nullable,
        super(key: key);

  final void Function(SelectableType?) _onSaved;
  final Widget Function(BuildContext, SelectableType?, bool) _itemBuilder;
  final Widget Function(SelectableType?) _displayItemBuilder;
  final String Function(SelectableType?) _buttonText;
  final String? Function(SelectableType?)? _validator;
  final List<SelectableType> _values;
  final String _selectionLabel;
  final SelectableType? _initial;
  final bool _nullable;

  @override
  _ButtonSelectState createState() => _ButtonSelectState<SelectableType>();
}

class _ButtonSelectState<SelectableType>
    extends State<ButtonSelect<SelectableType>> {
  _openSelectModal(BuildContext context, FormFieldState<SelectableType> state) {
    SelectableType? init = state.value;

    SelectDialog.showModal<SelectableType?>(
      context,
      label: widget._selectionLabel,
      selectedValue: init,
      items: [if (widget._nullable) null, ...widget._values],
      itemBuilder: widget._itemBuilder,
      onChange: (SelectableType? selected) {
        state.didChange(selected);
        state.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<SelectableType>(
      initialValue: widget._initial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<SelectableType> state) {
        return Column(
          children: [
            Row(children: [
              if (state.value != null) widget._displayItemBuilder(state.value),
              TextButton(
                  onPressed: () => _openSelectModal(context, state),
                  child: Text(widget._buttonText(state.value),
                      style: TextStyle(fontSize: 16)))
            ]),
            if (state.errorText != null)
              Text("${state.errorText}", style: TextStyle(color: Colors.red)),
          ],
        );
      },
      validator: widget._validator,
      onSaved: widget._onSaved,
    );
  }
}
