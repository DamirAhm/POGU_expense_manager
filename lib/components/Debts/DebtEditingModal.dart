import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/Common/ButtonSelect.dart';
import 'package:test_app/components/Common/FormInput.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/models/Debt.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/DebtsController.dart';

class DebtEditingModal extends StatefulWidget {
  DebtEditingModal(
      {required void Function(Debt) onSubmit,
      Debt? initialState,
      bool autoFocus = true,
      bool isEditing = false})
      : _onSubmit = onSubmit,
        _initialState = initialState,
        _autoFocus = autoFocus,
        _isEditing = isEditing;

  final void Function(Debt) _onSubmit;
  final Debt? _initialState;
  final bool _autoFocus;
  final bool _isEditing;

  @override
  _DebtEditingModalState createState() => _DebtEditingModalState(_initialState);
}

class _DebtEditingModalState extends State<DebtEditingModal> {
  _DebtEditingModalState(Debt? initState) {
    if (initState != null) {
      _nameController.text = initState.name;
      _amountController.text = initState.amount.toString();
      _descriptionController.text = initState.description;
      _account = initState.account;
      _debtType = initState.type;
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _nameController = TextEditingController(text: '');
  final _amountController = TextEditingController(text: '0');
  final _descriptionController = TextEditingController(text: '');

  Account? _account;
  DebtType _debtType = DebtType.lend;

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final amount = int.parse(_amountController.text);

      final newDebt =
          Debt(name: name, amount: amount, account: _account, type: _debtType);

      widget._onSubmit(newDebt);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<DebtsController, AccountsController>(
        builder: (context, debtsController, accountsController, child) => Form(
            key: _formKey,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //Name
                      FormInput(
                        controller: _nameController,
                        hintText: '?????????????? ???????????????? ??????????',
                        validator: (String? name) {
                          if (name == null || name.trim() == '') {
                            return '?????????????? ??????-????????????';
                          } else if (widget._initialState?.name != name &&
                              debtsController.findByName(name) != null) {
                            return '???????? ?? ?????????? ?????????????????? ?????? ????????????????????';
                          }
                        },
                        nextFieldFocusNode:
                            widget._autoFocus ? _amountFocusNode : null,
                        autoFocus: widget._autoFocus,
                        keyboardType: TextInputType.name,
                      ),
                      //Amount
                      FormInput(
                        controller: _amountController,
                        hintText: '?????????????? ?????????? ??????????',
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.trim() == '') {
                            return '?????????????? ?????? ????????????';
                          } else if (int.parse(value) < 0) {
                            return '?????????? ?????????? ???? ?????????? ???????? ??????????????????????????';
                          }
                        },
                        nextFieldFocusNode:
                            widget._autoFocus ? _descriptionFocusNode : null,
                        focusNode: _amountFocusNode,
                        onChanged: (value) {
                          if (value.trim() == '') {
                            _amountController.text = '0';
                          } else if (value.startsWith('0')) {
                            _amountController.text =
                                _amountController.text.substring(1);
                          }
                          _amountController.selection =
                              TextSelection.fromPosition(TextPosition(
                                  offset: _amountController.text.length));
                        },
                      ),
                      //Description
                      FormInput(
                        controller: _descriptionController,
                        hintText: '????????????????',
                        keyboardType: TextInputType.text,
                        focusNode: _descriptionFocusNode,
                      ),
                      if (widget._isEditing)
                        StaticValueContainer(_account == null
                            ? '?????? ??????????'
                            : "????????: ${_account!.name}")
                      else
                        ButtonSelect<Account?>(
                          onSaved: (selectedAccount) {
                            setState(() {
                              _account = selectedAccount;
                            });
                          },
                          itemBuilder: (context, account, _) => account == null
                              ? ListTile(
                                  title: Text('???? ???????????????????????? ????????'),
                                )
                              : ListTile(
                                  title: Text(account.name),
                                  trailing: Text('${account.amount}'),
                                ),
                          displayItemBuilder: (account) => Row(children: [
                            Text('????????: ', style: TextStyle(fontSize: 18)),
                            Text(account!.name, style: TextStyle(fontSize: 18))
                          ]),
                          buttonText: (account) =>
                              account == null ? '?????? ??????????' : '????????????????',
                          values: accountsController.accounts,
                          selectionLabel: "???????????????? ????????",
                          initial: _account,
                          nullable: true,
                        ),
                      if (widget._isEditing)
                        StaticValueContainer(
                            "??????: ${getDebtTypeName(_debtType)}")
                      else
                        ButtonSelect<DebtType>(
                          onSaved: (type) {
                            setState(() {
                              _debtType = type!;
                            });
                          },
                          values: DebtType.values.toList(),
                          initial: _debtType,
                          itemBuilder: (context, type, _) => Container(
                              child: ListTile(
                            title: Text(getDebtTypeName(type!)),
                          )),
                          displayItemBuilder: (type) => Row(children: [
                            Text('??????: ', style: TextStyle(fontSize: 18)),
                            Text(getDebtTypeName(type!),
                                style: TextStyle(fontSize: 18))
                          ]),
                          buttonText: (_) => '????????????????',
                          selectionLabel: '???????????????? ?????? ??????????',
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          child: const Text('??????????????????????'),
                        ),
                      ),
                    ]))));
  }
}

class StaticValueContainer extends StatelessWidget {
  const StaticValueContainer(this._value, {Key? key}) : super(key: key);

  final String _value;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text(_value, style: TextStyle(fontSize: 16)),
        padding: EdgeInsets.symmetric(vertical: 15));
  }
}
