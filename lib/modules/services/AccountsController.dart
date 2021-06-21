import 'package:test_app/modules/models/Account.dart';

class AccountsController {
  var _accounts = <Account>[];

  AccountsController({List<Account>? accounts}) {
    if (accounts != null) {
      this._accounts = accounts;
    }
  }

  void addAccount(Account account) => _accounts.add(account);
  void removeAccount(String accountId) =>
      _accounts.removeWhere((account) => account.id == accountId);
  Account? findByName(String name) {
    final filteredAccounts = _accounts
        .where((account) => account.name.toLowerCase() == name.toLowerCase());
    return filteredAccounts.length > 0 ? filteredAccounts.first : null;
  }

  Account? findById(String id) {
    final filteredAccounts = _accounts.where((account) => account.id == id);
    return filteredAccounts.length > 0 ? filteredAccounts.first : null;
  }

  List<Account> get accounts => _accounts;
}
