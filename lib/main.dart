import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/modules/models/Category.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/CategoriesController.dart';
import 'package:test_app/modules/services/SpendsController.dart';

import 'modules/models/Account.dart';
import 'modules/models/Spend.dart';
import 'pages/Accounts.dart';
import 'pages/Spends.dart';

final initialAccounts = [
  Account('Сбербанк', 2000,
      backgroundColor: Colors.green, textColor: Colors.white),
  Account('Альфа', 1000, backgroundColor: Colors.red, textColor: Colors.white)
];
final initialCategories = {
  "food": Category(name: 'Еда', icon: Icons.food_bank),
  "clothes": Category(name: "Одежда", icon: Icons.checkroom),
  "credits": Category(name: "Кредиты", icon: Icons.local_atm),
  "health": Category(name: "Здоровье", icon: Icons.local_hospital_outlined),
  "fun": Category(name: "Развлечения", icon: Icons.local_movies_rounded)
};
final initialSpends = [
  Spend(
      from: initialAccounts[0],
      amount: 100,
      category: initialCategories['food']!)
];

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => AccountsController(accounts: initialAccounts)),
      ChangeNotifierProvider(
          create: (context) => SpendsController(spends: initialSpends)),
      ChangeNotifierProvider(
          create: (context) => CategoriesController(
              categories: initialCategories.values.toList()))
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Word pair generator',
        theme: ThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) => AccountsPage(),
          '/spends': (context) => SpendsPage()
        });
  }
}
