import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/services/AccountsController.dart';

class AccountSelect extends StatefulWidget {
  AccountSelect(this._onSaved, {Key? key}) : super(key: key);

  final void Function(Account) _onSaved;

  @override
  _AccountSelectState createState() => _AccountSelectState();
}

class _AccountSelectState extends State<AccountSelect> {
  _openAccountSelectModal(BuildContext context, FormFieldState<Account> state) {
    final accountsController =
        Provider.of<AccountsController>(context, listen: false);
    Account? init = state.value;

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
