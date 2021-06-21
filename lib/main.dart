import 'package:flutter/material.dart';

import 'pages/Accounts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Word pair generator',
        theme: ThemeData(primaryColor: Colors.white),
        home: AccountsPage());
  }
}
