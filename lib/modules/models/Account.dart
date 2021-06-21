import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Account {
  String name;
  late String id;
  int amount;

  late ThemeData theme;

  Account(this.name, this.amount,
      {textColor = Colors.black, backgroundColor = Colors.white}) {
    final random = Random();
    id = random.nextInt(1000000000).toRadixString(16);

    theme = ThemeData(backgroundColor: backgroundColor, accentColor: textColor);
  }
}
