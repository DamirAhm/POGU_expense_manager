import 'package:flutter/material.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewAccountModal extends StatefulWidget {
  NewAccountModal(
      {required Function(Account) onSubmit,
      required Function(String) validateAccountName,
      Account? initialState,
      bool autoFocus = true})
      : _onSubmit = onSubmit,
        _validateAccountName = validateAccountName,
        _initialState = initialState,
        _autoFocus = autoFocus;

  final Function(Account) _onSubmit;
  final Function(String) _validateAccountName;
  final Account? _initialState;
  final bool _autoFocus;

  @override
  _NewAccountModalState createState() => _NewAccountModalState(_initialState);
}

class _NewAccountModalState extends State<NewAccountModal> {
  _NewAccountModalState(Account? initState) {
    if (initState != null) {
      _nameController.text = initState.name;
      _amountController.text = initState.amount.toString();
      _backgroundColor = initState.theme.backgroundColor;
      _textColor = initState.theme.accentColor;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  var _backgroundColor = Colors.white;
  var _textColor = Colors.black;

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final amount = int.parse(_amountController.text);

      final newAccount = Account(name, amount,
          backgroundColor: _backgroundColor, textColor: _textColor);

      widget._onSubmit(newAccount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  NameInput(
                      controller: _nameController,
                      validator: widget._validateAccountName,
                      nextFieldFocusNode: _amountFocusNode,
                      autoFocus: widget._autoFocus),
                  AmountInput(
                      focusNode: _amountFocusNode,
                      controller: _amountController),
                  ColorPickInput(
                      handleChange: (Color newColor) => setState(() {
                            _backgroundColor = newColor;
                          }),
                      title: 'Background color',
                      initialColor: _backgroundColor),
                  ColorPickInput(
                      handleChange: (Color newColor) => setState(() {
                            _textColor = newColor;
                          }),
                      title: 'Text color',
                      initialColor: _textColor),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      onPressed: _handleSubmit,
                      child: const Text('Submit'),
                    ),
                  ),
                ])));
  }
}

class ColorPickInput extends StatefulWidget {
  ColorPickInput(
      {Key? key,
      required Function(Color) handleChange,
      required String title,
      Color initialColor = Colors.white})
      : _handleChange = handleChange,
        _initialColor = initialColor,
        _title = title,
        super(key: key);

  final String _title;
  final Color _initialColor;
  final Function(Color) _handleChange;

  @override
  _ColorPickInputState createState() => _ColorPickInputState(_initialColor);
}

class _ColorPickInputState extends State<ColorPickInput> {
  late Color _pickerColor;

  _ColorPickInputState(Color initialColor) : _pickerColor = initialColor;

  void changeColor(Color color) {
    setState(() => _pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(child: Text(widget._title, style: TextStyle(fontSize: 18))),
      TextButton(
          onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Pick a color!'),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: _pickerColor,
                      onColorChanged: changeColor,
                      enableLabel: true,
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('Got it'),
                      onPressed: () {
                        widget._handleChange(_pickerColor);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black),
                color: _pickerColor),
          ))
    ]);
  }
}

class NameInput extends StatelessWidget {
  const NameInput(
      {Key? key,
      required TextEditingController controller,
      required Function(String p1) validator,
      required FocusNode nextFieldFocusNode,
      bool autoFocus = true})
      : _controller = controller,
        _validator = validator,
        _nextFieldFocusNode = nextFieldFocusNode,
        _autoFocus = autoFocus,
        super(key: key);

  final TextEditingController _controller;
  final Function(String p1) _validator;
  final FocusNode _nextFieldFocusNode;
  final bool _autoFocus;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
          autofocus: _autoFocus,
          controller: _controller,
          keyboardType: TextInputType.name,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: const InputDecoration(
            hintText: 'Enter account name',
          ),
          validator: (String? value) {
            if (value == null || value.isEmpty) {
              return 'Please enter some text';
            } else if (!_validator(value)) {
              return 'Account with the same name already exists';
            }
            return null;
          },
          onFieldSubmitted: (value) =>
              {if (_autoFocus) _nextFieldFocusNode.requestFocus()},
        ),
        margin: EdgeInsets.only(bottom: 10));
  }
}

class AmountInput extends StatelessWidget {
  const AmountInput({
    Key? key,
    required FocusNode focusNode,
    required TextEditingController controller,
  })  : _focusNode = focusNode,
        _controller = controller,
        super(key: key);

  final FocusNode _focusNode;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
          focusNode: _focusNode,
          controller: _controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter amount of money on this account',
          ),
        ),
        margin: EdgeInsets.only(bottom: 10));
  }
}