import 'package:flutter/cupertino.dart';
import 'package:test_app/modules/models/Account.dart';

class AccountsController extends ChangeNotifier {
  final _accounts = <Account>[];

  AccountsController({List<Account>? accounts}) {
    if (accounts != null) {
      _accounts.addAll(accounts);
    }
  }

  void addAccount(Account account) {
    _accounts.add(account);
    notifyListeners();
  }

  void removeAccount(String accountName) {
    _accounts.removeWhere((account) => account.name == accountName);
    notifyListeners();
  }

  void updateByName(String name, Account updatedAccount) {
    final indexOfAccount =
        _accounts.indexWhere((account) => account.name == name);

    if (indexOfAccount != -1) {
      _accounts[indexOfAccount] = updatedAccount;
      notifyListeners();
    }
  }

  void changeAmountByName(String name, {int? newAmount, int? diff}) {
    final accountToUpdate = findByName(name);

    if (accountToUpdate != null) {
      if (newAmount != null) {
        accountToUpdate.amount = newAmount;
      } else if (diff != null) {
        accountToUpdate.amount += diff;
      } else {
        throw new TypeError();
      }
      notifyListeners();
    }
  }

  Account? findByName(String name) {
    final filteredAccounts = _accounts
        .where((account) => account.name.toLowerCase() == name.toLowerCase());
    return filteredAccounts.length > 0 ? filteredAccounts.first : null;
  }

  List<Account> get accounts => _accounts;
}
