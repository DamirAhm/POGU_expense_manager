import 'package:flutter/cupertino.dart';
import 'package:test_app/modules/models/Spend.dart';

class SpendsController extends ChangeNotifier {
  final _spends = <Spend>[];

  SpendsController({List<Spend>? spends}) {
    if (spends != null) {
      _spends.addAll(spends);
    }
  }

  void addSpend(Spend spend) {
    _spends.add(spend);
    notifyListeners();
  }

  // void removeSpend(String SpendId) {
  //   _spends.removeWhere((Spend) => Spend.id == SpendId);
  //   notifyListeners();
  // }

  Spend? findById(String id) {
    final filteredSpends = _spends.where((spend) => spend.id == id);
    return filteredSpends.length > 0 ? filteredSpends.first : null;
  }

  // int findIndex(String id) => _spends.indexWhere((spend) => spend.id == id);

  List<Spend> get spends => _spends;
}
