import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/models/Category.dart';
import 'package:test_app/modules/models/Spend.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/CategoriesController.dart';

class SpendCreationModal extends StatefulWidget {
  SpendCreationModal(
      {required Function(Spend) onSubmit,
      Spend? initialState,
      bool autoFocus = true})
      : _onSubmit = onSubmit,
        _autoFocus = autoFocus;

  final Function(Spend) _onSubmit;
  final bool _autoFocus;

  @override
  _SpendCreationModalState createState() => _SpendCreationModalState();
}

class _SpendCreationModalState extends State<SpendCreationModal> {
  final _formKey = GlobalKey<FormState>();

  final _amountFocusNode = FocusNode();
  final _amountController = TextEditingController();

  Account? _from;
  Category? _category;

  int _selectedIndex = 0;

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      final amount = int.parse(_amountController.text);
      final newSpend =
          Spend(amount: amount, category: _category!, from: _from!);

      widget._onSubmit(newSpend);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AccountsController, CategoriesController>(
        builder: (context, accountsController, categoriesController, child) =>
            Form(
                key: _formKey,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          AmountInput(
                              focusNode: _amountFocusNode,
                              controller: _amountController),
                          AccountSelect((acc) => setState(() => _from = acc)),
                          CategorySelect((category) =>
                              setState(() => _category = category)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              child: const Text('Подтвердить'),
                            ),
                          ),
                        ]))));
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
            hintText: 'Введите сумму траты',
          ),
        ),
        margin: EdgeInsets.only(bottom: 10));
  }
}

class AccountSelect extends StatefulWidget {
  AccountSelect(this._onSaved, {Key? key}) : super(key: key);

  final Function(Account) _onSaved;

  @override
  _AccountSelectState createState() => _AccountSelectState();
}

class _AccountSelectState extends State<AccountSelect> {
  Account? _selected;

  _openAccountSelectModal(BuildContext context, FormFieldState<Account> state) {
    final accountsController =
        Provider.of<AccountsController>(context, listen: false);
    Account? init = _selected;

    SelectDialog.showModal<Account>(
      context,
      label: "Выберите счёт",
      selectedValue: init,
      items: accountsController.accounts,
      itemBuilder: (BuildContext context, Account account, _) => Container(
          child: ListTile(
        title: Text(account.name),
        trailing: Text('${account.amount}'),
      )),
      onChange: (Account selected) {
        state.didChange(selected);
        state.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Account>(
      initialValue: null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<Account> state) {
        return Column(
          children: <Widget>[
            Row(children: [
              if (state.value != null)
                Row(children: [
                  Text('Счёт: ', style: TextStyle(fontSize: 18)),
                  Text(state.value!.name, style: TextStyle(fontSize: 18))
                ]),
              TextButton(
                  onPressed: () => _openAccountSelectModal(context, state),
                  child:
                      Text(state.value == null ? 'Выберите счёт' : 'Изменить'))
            ]),
            state.errorText == null
                ? Text("")
                : Text(state.errorText!, style: TextStyle(color: Colors.red)),
          ],
        );
      },
      validator: (val) => val != null ? null : "Выберите счёт",
      onSaved: (val) => widget._onSaved(val!),
    );
  }
}

class CategorySelect extends StatefulWidget {
  CategorySelect(this._onSaved, {Key? key}) : super(key: key);
  final Function(Category) _onSaved;

  @override
  _CategorySelectState createState() => _CategorySelectState();
}

class _CategorySelectState extends State<CategorySelect> {
  Category? _selected;

  _openCategorySelectModal(FormFieldState<Category> state) {
    final categoriesController =
        Provider.of<CategoriesController>(context, listen: false);
    Category? init = _selected;

    SelectDialog.showModal<Category>(
      context,
      label: "Выберите категорию",
      selectedValue: init,
      items: categoriesController.categories,
      itemBuilder: (BuildContext context, Category item, _) =>
          ListTile(title: Text(item.name), leading: Icon(item.icon)),
      onChange: (Category selected) {
        state.didChange(_selected = selected);
        state.save();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<Category>(
      initialValue: null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      builder: (FormFieldState<Category> state) {
        return Column(
          children: <Widget>[
            Row(children: [
              if (_selected != null)
                Row(children: [
                  Text('Категория: ', style: TextStyle(fontSize: 18)),
                  Container(
                    child: Icon(_selected!.icon),
                    margin: EdgeInsets.only(right: 7),
                  ),
                  Text(_selected!.name, style: TextStyle(fontSize: 18))
                ]),
              TextButton(
                  child: Text(
                      _selected != null ? 'Изменить' : 'Выберите категорию'),
                  onPressed: () => _openCategorySelectModal(state))
            ]),
            state.errorText == null
                ? Text("")
                : Text(state.errorText!, style: TextStyle(color: Colors.red)),
          ],
        );
      },
      validator: (val) => val != null ? null : "Выберите категорию",
      onSaved: (val) => widget._onSaved(val!),
    );
  }
}
