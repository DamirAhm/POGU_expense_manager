import 'package:test_app/utils/random.dart';

import 'Account.dart';
import 'Category.dart';

class Spend {
  Spend(
      {required Account from,
      required int amount,
      required Category category}) {
    _from = from;
    _amount = amount;
    _category = category;

    _id = getRandomId();
  }

  late final String _id;
  late final Account _from;
  late final int _amount;
  late Category _category;

  Account get from => this._from;
  int get amount => this._amount;
  Category get category => this._category;
  String get id => this._id;
}
