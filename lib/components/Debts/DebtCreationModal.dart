import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:test_app/components/Common/AccountSelect.dart';
import 'package:test_app/components/Common/FormInput.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/models/Debt.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/DebtsController.dart';

class DebtEditingModal extends StatefulWidget {
  DebtEditingModal(
      {required void Function(Debt) onSubmit,
      Debt? initialState,
      bool autoFocus = true})
      : _onSubmit = onSubmit,
        _initialState = initialState,
        _autoFocus = autoFocus;

  final void Function(Debt) _onSubmit;
  final Debt? _initialState;
  final bool _autoFocus;

  @override
  _DebtEditingModalState createState() => _DebtEditingModalState(_initialState);
}

class _DebtEditingModalState extends State<DebtEditingModal> {
  _DebtEditingModalState(Debt? initState) {
    if (initState != null) {
      _nameController.text = initState.name;
      _amountController.text = initState.amount.toString();
    }
  }

  final _formKey = GlobalKey<FormState>();
  final _amountFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  Account? _account;
  DebtType _debtType = DebtType.lend;

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final amount = int.parse(_amountController.text);

      final newDebt = Debt(name: name, amount: amount, account: _account);

      widget._onSubmit(newDebt);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DebtsController>(
        builder: (context, debtsController, child) => Form(
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
                        hintText: 'Введите название долга',
                        validator: (String? name) {
                          if (name == null || name.trim() == '') {
                            return 'Введите что-нибудь';
                          } else if (widget._initialState?.name != name &&
                              debtsController.findByName(name) != null) {
                            return 'Долг с таким названием уже существует';
                          }
                        },
                        nextFieldFocusNode: _amountFocusNode,
                        autoFocus: true,
                        keyboardType: TextInputType.name,
                      ),
                      //Amount
                      FormInput(
                        controller: _amountController,
                        hintText: 'Введите сумму долга',
                        keyboardType: TextInputType.number,
                        initialValue: '0',
                        validator: (String? value) {
                          if (value == null || value.trim() == '') {
                            return 'Введите что нибудь';
                          } else if (int.parse(value) < 0) {
                            return 'Сумма долга не может быть отрицательной';
                          }
                        },
                        nextFieldFocusNode: _descriptionFocusNode,
                        focusNode: _amountFocusNode,
                      ),
                      //Description
                      FormInput(
                        controller: _descriptionController,
                        hintText: 'Описание',
                        keyboardType: TextInputType.text,
                        focusNode: _descriptionFocusNode,
                      ),
                      AccountSelect(
                          (selectedAccount) => _account = selectedAccount),
                      DebtTypeSelect((type) => _debtType = type,
                          initial: _debtType),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          child: const Text('Подтвердить'),
                        ),
                      ),
                    ]))));
  }
}

class DebtTypeSelect extends StatefulWidget {
  DebtTypeSelect(this._onSaved, {DebtType initial = DebtType.lend, Key? key})
      : _initial = initial,
        super(key: key);

  final void Function(DebtType) _onSaved;
  final DebtType _initial;

  @override
  _DebtTypeSelectState createState() => _DebtTypeSelectState();
}

class _DebtTypeSelectState extends State<DebtTypeSelect> {
  _openAccountSelectModal(
      BuildContext context, FormFieldState<DebtType> state) {
    SelectDialog.showModal<DebtType>(
      context,
      label: "Выберите счёт",
      showSearchBox: false,
      selectedValue: state.value,
      items: DebtType.values.toList(),
      itemBuilder: (BuildContext context, DebtType type, _) => Container(
          child: ListTile(
        title: Text(getTypeName(type)),
      )),
      onChange: (DebtType selected) {
        state.didChange(selected);
        state.save();
      },
    );
  }

  String getTypeName(DebtType type) {
    switch (type) {
      case DebtType.lend:
        {
          return 'Дать в долг';
        }
      case DebtType.owe:
        {
          return 'Взять в долг';
        }
      default:
        {
          throw new TypeError();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<DebtType>(
      initialValue: widget._initial,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<DebtType> state) {
        return Column(
          children: <Widget>[
            Row(children: [
              Row(children: [
                Text('Тип: ', style: TextStyle(fontSize: 18)),
                Text(getTypeName(state.value!), style: TextStyle(fontSize: 18))
              ]),
              TextButton(
                  onPressed: () => _openAccountSelectModal(context, state),
                  child: Text('Изменить'))
            ]),
          ],
        );
      },
      onSaved: (val) => widget._onSaved(val!),
    );
  }
}
