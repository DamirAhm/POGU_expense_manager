import 'package:test_app/modules/models/Account.dart';

enum DebtType { owe, lend }

String getDebtTypeName(DebtType type) {
  switch (type) {
    case DebtType.lend:
      {
        return 'Дать в долг';
      }
    case DebtType.owe:
      {
        return 'Взять в долг';
      }
    default:
      {
        throw new TypeError();
      }
  }
}

class Debt {
  late int _amount;
  late String _name;
  late String _description;
  late DebtType _type;
  late DateTime _createDate;
  late Account? _account;

  Debt(
      {required int amount,
      required String name,
      String description = '',
      DebtType type = DebtType.lend,
      Account? account}) {
    _amount = amount;
    _name = name;
    _type = type;
    _description = description;
    _account = account;
    _createDate = DateTime.now();
  }

  int get amount => this._amount;
  set amount(int value) => this._amount = value;

  String get name => this._name;
  set name(String value) => this._name = value;

  String get description => this._description;
  set description(String value) => this._description = value;

  DebtType get type => this._type;
  DateTime get createDate => this._createDate;
  Account? get account => this._account;
}
