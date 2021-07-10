import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_app/utils/random.dart';

class Account {
  final String _name;
  late final String _id;
  int _amount;

  late ThemeData theme;

  Account(this._name, this._amount,
      {textColor = Colors.black, backgroundColor = Colors.white}) {
    _id = getRandomId();

    theme = ThemeData(backgroundColor: backgroundColor, accentColor: textColor);
  }

  String get name => this._name;

  String get id => this._id;

  int get amount => this._amount;
  set amount(int amount) => this._amount = amount;
}
