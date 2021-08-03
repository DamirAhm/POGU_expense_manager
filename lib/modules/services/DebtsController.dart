import 'package:flutter/cupertino.dart';
import 'package:test_app/modules/models/Debt.dart';

class DebtsController extends ChangeNotifier {
  final _debts = <Debt>[];

  DebtsController({List<Debt>? debts}) {
    if (debts != null) {
      _debts.addAll(debts);
    }
  }

  void addDebt(Debt debt) {
    _debts.add(debt);
    notifyListeners();
  }

  void removeDebt(String debtName) {
    _debts.removeWhere((debt) => debt.name == debtName);
    notifyListeners();
  }

  Debt? findByName(String name) {
    final filteredSpends =
        _debts.where((debt) => debt.name.toLowerCase() == name.toLowerCase());
    return filteredSpends.length > 0 ? filteredSpends.first : null;
  }

  void updateByName(String name, Debt updatedDebt) {
    int indexOfDebt = _debts.indexWhere((debt) => debt.name == name);

    if (indexOfDebt != -1) {
      _debts[indexOfDebt] = updatedDebt;
      notifyListeners();
    }
  }

  List<Debt> get debts => _debts;
}
