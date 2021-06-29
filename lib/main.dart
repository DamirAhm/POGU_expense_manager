import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/modules/services/AccountsController.dart';

import 'modules/models/Account.dart';
import 'pages/Accounts.dart';

void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider(
          create: (context) => AccountsController(accounts: [
                Account('Сбербанк', 2000,
                    backgroundColor: Colors.green, textColor: Colors.white),
                Account('Альфа', 1000,
                    backgroundColor: Colors.red, textColor: Colors.white)
              ]))
    ], child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Word pair generator',
        theme: ThemeData(primaryColor: Colors.white),
        home: AccountsPage());
  }
}
