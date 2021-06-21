import 'package:flutter/material.dart';
import 'package:test_app/components/NewAccountModal.dart';
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

  void addAccount(Account newAccount) {
    setState(() {
      _accountsController.addAccount(newAccount);
    });
  }

  void _openNewAccountModal() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return NewAccountModal(addAccount, (newAccountName) {
            print(_accountsController.findByName(newAccountName));
            return _accountsController.findByName(newAccountName) == null;
          });
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
                    tiles: _accountsController.accounts
                        .map((account) => AccountTile(account)),
                    context: context)
                .toList()));
  }
}

class AccountTile extends StatelessWidget {
  final Account account;
  AccountTile(this.account);

  @override
  Widget build(BuildContext context) {
    final _nameFontSize = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: account.theme.accentColor);
    final _cashFont = TextStyle(fontSize: 16, color: account.theme.accentColor);

    return Container(
        child: ListTile(
          title: Text(account.name, style: _nameFontSize),
          trailing: Text('${account.amount}', style: _cashFont),
        ),
        color: account.theme.backgroundColor);
  }
}
