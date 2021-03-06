import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/Common/FormInput.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_app/modules/services/AccountsController.dart';

class AccountEditingModal extends StatefulWidget {
  AccountEditingModal(
      {required void Function(Account) onSubmit,
      Account? initialState,
      bool autoFocus = true})
      : _onSubmit = onSubmit,
        _initialState = initialState,
        _autoFocus = autoFocus;

  final void Function(Account) _onSubmit;
  final Account? _initialState;
  final bool _autoFocus;

  @override
  _AccountEditingModalState createState() =>
      _AccountEditingModalState(_initialState);
}

class _AccountEditingModalState extends State<AccountEditingModal> {
  _AccountEditingModalState(Account? initState) {
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

      final newAccount = Account(
          name: name,
          amount: amount,
          backgroundColor: _backgroundColor,
          textColor: _textColor);

      widget._onSubmit(newAccount);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsController>(
        builder: (context, accountsController, child) => Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      FormInput(
                        controller: _nameController,
                        hintText: '?????????????? ???????????????? ??????????',
                        validator: (String? value) {
                          if (value == null || value.trim() == '') {
                            return '?????????????? ??????-????????????';
                          } else if (widget._initialState?.name != value &&
                              accountsController.findByName(value) != null) {
                            return '???????? ?? ?????????? ?????????????????? ?????? ????????????????????';
                          }
                        },
                        nextFieldFocusNode: _amountFocusNode,
                        autoFocus: widget._autoFocus,
                        keyboardType: TextInputType.name,
                      ),
                      //Amount
                      FormInput(
                        controller: _amountController,
                        hintText: '?????????????? ???????????????????? ?????????? ???? ??????????',
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.trim() == '') {
                            return '?????????????? ??????-????????????';
                          } else if (int.parse(value) < 0) {
                            return '???????????????????? ?????????? ???? ?????????? ???????? ??????????????????????????';
                          }
                        },
                        focusNode: _amountFocusNode,
                      ),
                      ColorPickInput(
                          handleChange: (Color newColor) => setState(() {
                                _backgroundColor = newColor;
                              }),
                          title: '???????? ????????',
                          initialColor: _backgroundColor),
                      ColorPickInput(
                          handleChange: (Color newColor) => setState(() {
                                _textColor = newColor;
                              }),
                          title: '???????? ????????????',
                          initialColor: _textColor),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          child: const Text('??????????????????????'),
                        ),
                      ),
                    ]))));
  }
}

class ColorPickInput extends StatefulWidget {
  ColorPickInput(
      {Key? key,
      required void Function(Color) handleChange,
      required String title,
      Color initialColor = Colors.white})
      : _handleChange = handleChange,
        _initialColor = initialColor,
        _title = title,
        super(key: key);

  final String _title;
  final Color _initialColor;
  final void Function(Color) _handleChange;

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
                  title: const Text('???????????????? ????????'),
                  content: SingleChildScrollView(
                    child: MaterialPicker(
                      pickerColor: _pickerColor,
                      onColorChanged: changeColor,
                      enableLabel: true,
                    ),
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      child: const Text('????????????????'),
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
