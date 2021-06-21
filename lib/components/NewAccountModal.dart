import 'package:flutter/material.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewAccountModal extends StatefulWidget {
  final Function(Account) _addAccount;
  final Function(String) _validateAccountName;
  NewAccountModal(this._addAccount, this._validateAccountName);

  @override
  _NewAccountModalState createState() => _NewAccountModalState();
}

class _NewAccountModalState extends State<NewAccountModal> {
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

      widget._addAccount(newAccount);
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
                      nextFieldFocusNode: _amountFocusNode),
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
  const NameInput({
    Key? key,
    required TextEditingController controller,
    required Function(String p1) validator,
    required FocusNode nextFieldFocusNode,
  })  : _controller = controller,
        _validator = validator,
        _nextFieldFocusNode = nextFieldFocusNode,
        super(key: key);

  final TextEditingController _controller;
  final Function(String p1) _validator;
  final FocusNode _nextFieldFocusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextFormField(
          autofocus: true,
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
          onFieldSubmitted: (value) => _nextFieldFocusNode.requestFocus(),
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
