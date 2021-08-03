import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/Accounts/AccountEditingModal.dart';
import 'package:test_app/components/Common/MyScaffold.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/services/AccountsController.dart';

class AccountsPage extends StatefulWidget {
  AccountsPage({Key? key}) : super(key: key);

  @override
  _AccountsPageState createState() => _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  void _openNewAccountModal() {
    final accountsController =
        Provider.of<AccountsController>(context, listen: false);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AccountEditingModal(
              onSubmit: (Account newAccount) =>
                  accountsController.addAccount(newAccount));
        });
  }

  void _openAccountEditingModal(Account accountToUpdate) {
    final accountsController = Provider.of<AccountsController>(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AccountEditingModal(
            onSubmit: (Account updatedAccount) => accountsController
                .updateByName(accountToUpdate.name, updatedAccount),
            initialState: accountToUpdate,
            autoFocus: false,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AccountsController>(
        builder: (context, accountsController, child) => MyScaffold(
              title: 'Счета',
              actions: [
                IconButton(
                    onPressed: () => _openNewAccountModal(),
                    icon: Icon(Icons.add))
              ],
              body: ListView(
                  children: ListTile.divideTiles(
                          tiles: accountsController.accounts.map((account) =>
                              AccountTile(
                                  account: account,
                                  onPressed: () =>
                                      _openAccountEditingModal(account))),
                          context: context)
                      .toList()),
            ));
  }
}

class AccountTile extends StatelessWidget {
  final Account _account;
  final void Function() _onPressed;
  AccountTile({required Account account, required void Function() onPressed})
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
