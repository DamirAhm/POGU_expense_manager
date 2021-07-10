import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/MyScaffold.dart';
import 'package:test_app/components/SpendCreationModal.dart';
import 'package:test_app/modules/models/Spend.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/SpendsController.dart';

class SpendsPage extends StatefulWidget {
  SpendsPage({Key? key}) : super(key: key);

  @override
  _SpendsPageState createState() => _SpendsPageState();
}

class _SpendsPageState extends State<SpendsPage> {
  _openSpendCreationModal() {
    final spendsController =
        Provider.of<SpendsController>(context, listen: false);
    final accountsController =
        Provider.of<AccountsController>(context, listen: false);

    showModalBottomSheet(
        context: context,
        builder: (context) => SpendCreationModal(onSubmit: (newSpend) {
              spendsController.addSpend(newSpend);
              accountsController.changeAmountById(
                  newSpend.from.id, newSpend.from.amount - newSpend.amount);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SpendsController>(
        builder: (context, spendsController, child) => MyScaffold(
            title: 'Траты',
            actions: [
              IconButton(
                  onPressed: _openSpendCreationModal, icon: Icon(Icons.add)),
              IconButton(
                  onPressed: () {}, icon: Icon(Icons.filter_alt_outlined))
            ],
            body: Container(
                child: ListView(
                    children: spendsController.spends
                        .map((spend) => SpendTile(spend))
                        .toList()))));
  }
}

class SpendTile extends StatelessWidget {
  SpendTile(this._spend, {Key? key})
      : _textColor = TextStyle(color: _spend.from.theme.accentColor),
        super(key: key);

  final Spend _spend;
  late final _textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListTile(
          leading:
              Icon(_spend.category.icon, color: _spend.from.theme.accentColor),
          title: Text(_spend.from.name, style: _textColor),
          trailing: Text(_spend.amount.toString(), style: _textColor),
        ),
        color: _spend.from.theme.backgroundColor);
  }
}
