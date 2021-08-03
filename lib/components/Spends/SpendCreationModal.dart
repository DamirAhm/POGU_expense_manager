import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:test_app/components/Common/AccountSelect.dart';
import 'package:test_app/components/Common/FormInput.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/models/Category.dart';
import 'package:test_app/modules/models/Spend.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/CategoriesController.dart';

class SpendCreationModal extends StatefulWidget {
  SpendCreationModal({required void Function(Spend) onSubmit})
      : _onSubmit = onSubmit;

  final void Function(Spend) _onSubmit;

  @override
  _SpendCreationModalState createState() => _SpendCreationModalState();
}

class _SpendCreationModalState extends State<SpendCreationModal> {
  final _formKey = GlobalKey<FormState>();

  final _amountController = TextEditingController();

  Account? _from;
  Category? _category;

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
                          //Amount
                          FormInput(
                            controller: _amountController,
                            hintText: 'Введите сумму',
                            keyboardType: TextInputType.number,
                            validator: (String? value) {
                              if (value == null || value.trim() == '') {
                                return 'Введите что-нибудь';
                              } else if (int.parse(value) < 0) {
                                return 'Сумма не может быть отрицательной';
                              }
                            },
                          ),
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

class CategorySelect extends StatefulWidget {
  CategorySelect(this._onSaved, {Key? key}) : super(key: key);
  final void Function(Category) _onSaved;

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
