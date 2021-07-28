import 'package:flutter/material.dart';

class Account {
  final String _name;
  int _amount;

  late ThemeData theme;

  Account(
      {required String name,
      required int amount,
      textColor = Colors.black,
      backgroundColor = Colors.white})
      : _name = name,
        _amount = amount,
        theme =
            ThemeData(backgroundColor: backgroundColor, accentColor: textColor);

  String get name => this._name;

  int get amount => this._amount;
  set amount(int amount) => this._amount = amount;
}
