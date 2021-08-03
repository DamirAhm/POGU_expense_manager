import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/modules/models/Category.dart';
import 'package:test_app/modules/models/Debt.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/CategoriesController.dart';
import 'package:test_app/modules/services/DebtsController.dart';
import 'package:test_app/modules/services/SpendsController.dart';
import 'package:test_app/pages/Debts.dart';

import 'modules/models/Account.dart';
import 'modules/models/Spend.dart';
import 'pages/Accounts.dart';
import 'pages/Spends.dart';

final initialAccounts = [
  Account(
      name: 'Сбербанк',
      amount: 2000,
      backgroundColor: Colors.green,
      textColor: Colors.white),
  Account(
      name: 'Альфа',
      amount: 1000,
      backgroundColor: Colors.red,
      textColor: Colors.white)
];
final initialCategories = [
  Category(name: 'Еда', icon: Icons.food_bank),
  Category(name: "Одежда", icon: Icons.checkroom),
  Category(name: "Кредиты", icon: Icons.local_atm),
  Category(name: "Здоровье", icon: Icons.local_hospital_outlined),
  Category(name: "Развлечения", icon: Icons.local_movies_rounded)
];
final initialSpends = [
  Spend(from: initialAccounts[0], amount: 100, category: initialCategories[0])
];
final initialDebts = [
  Debt(amount: 200, name: "Кирилл", description: '', type: DebtType.lend),
  Debt(amount: 260, name: "Даниил", description: '', type: DebtType.lend),
  Debt(amount: 400, name: "Денис", description: '', type: DebtType.lend),
];

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => AccountsController(accounts: initialAccounts)),
      ChangeNotifierProvider(
          create: (context) => SpendsController(spends: initialSpends)),
      ChangeNotifierProvider(
          create: (context) =>
              CategoriesController(categories: initialCategories)),
      ChangeNotifierProvider(
          create: (context) => DebtsController(debts: initialDebts))
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'POGU',
        theme: ThemeData(primaryColor: Colors.blue, accentColor: Colors.white),
        initialRoute: '/',
        routes: {
          '/': (context) => AccountsPage(),
          '/spends': (context) => SpendsPage(),
          '/debts': (context) => DebtsPage(),
        });
  }
}
