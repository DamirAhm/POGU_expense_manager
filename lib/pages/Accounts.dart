import 'package:flutter/material.dart';
import 'package:test_app/components/AccountEditingModal.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/services/AccountsController.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  final _accountsController = AccountsController(accounts: [
    Account('Сбербанк', 2000,
        backgroundColor: Colors.green, textColor: Colors.white),
    Account('Альфа', 1000, backgroundColor: Colors.red, textColor: Colors.white)
  ]);

  void _addAccount(Account newAccount) {
    setState(() {
      _accountsController.addAccount(newAccount);
    });
  }

  void _updateAccount(String accountId, Account updatedAccount) {
    setState(() {
      _accountsController.updateById(accountId, updatedAccount);
    });
  }

  void _openNewAccountModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return NewAccountModal(
              onSubmit: _addAccount,
              validateAccountName: (newAccountName) {
                print(_accountsController.findByName(newAccountName));
                return _accountsController.findByName(newAccountName) == null;
              });
        });
  }

  void _openAccountEditingModal(Account accountToUpdate) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return NewAccountModal(
            onSubmit: (updatedAccount) =>
                _updateAccount(accountToUpdate.id, updatedAccount),
            validateAccountName: (newAccountName) {
              return newAccountName == accountToUpdate.name ||
                  _accountsController.findByName(newAccountName) == null;
            },
            initialState: accountToUpdate,
            autoFocus: false,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Cash accounts'),
          actions: [
            IconButton(onPressed: _openNewAccountModal, icon: Icon(Icons.add))
          ],
        ),
        body: ListView(
            children: ListTile.divideTiles(
                    tiles: _accountsController.accounts.map((account) =>
                        AccountTile(
                            account: account,
                            onPressed: () =>
                                _openAccountEditingModal(account))),
                    context: context)
                .toList()));
  }
}

class AccountTile extends StatelessWidget {
  final Account _account;
  final Function() _onPressed;
  AccountTile({required Account account, required Function() onPressed})
      : _account = account,
        _onPressed = onPressed;

  @override
  Widget build(BuildContext context) {
    final _nameFontSize = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _account.theme.accentColor);
    final _cashFont =
        TextStyle(fontSize: 16, color: _account.theme.accentColor);

    return Container(
        child: ListTile(
          title: Text(_account.name, style: _nameFontSize),
          trailing: Text('${_account.amount}', style: _cashFont),
          onTap: _onPressed,
        ),
        color: _account.theme.backgroundColor);
  }
}
