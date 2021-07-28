import 'package:flutter/material.dart';

import 'AppDrawer.dart';

class MyScaffold extends StatelessWidget {
  const MyScaffold(
      {required String title,
      required Widget body,
      List<Widget> actions = const <Widget>[],
      Key? key})
      : this._title = title,
        this._body = body,
        this._actions = actions,
        super(key: key);

  final String _title;
  final List<Widget> _actions;
  final Widget _body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(_title),
        actions: _actions,
        leading: Builder(
            builder: (context) => IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )),
      ),
      body: _body,
      drawer: AppDrawer(),
    );
  }
}
