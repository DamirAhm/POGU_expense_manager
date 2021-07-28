import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/Spends/CategoriesFilterModal.dart';
import 'package:test_app/components/Common/MyScaffold.dart';
import 'package:test_app/components/Spends/SpendCreationModal.dart';
import 'package:test_app/modules/models/Category.dart';
import 'package:test_app/modules/models/Spend.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/CategoriesController.dart';
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
              accountsController.changeAmountByName(
                  newSpend.from.name, newSpend.from.amount - newSpend.amount);
            }));
  }

  _openCategoriesFilterModal() {
    final categoryController =
        Provider.of<CategoriesController>(context, listen: false);

    showModalBottomSheet(
        context: context, builder: (context) => CategoriesFilterModal());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SpendsController, CategoriesController>(
        builder: (context, spendsController, categoriesController, child) =>
            MyScaffold(
                title: 'Траты',
                actions: [
                  IconButton(
                      onPressed: _openCategoriesFilterModal,
                      icon: Icon(Icons.filter_alt_outlined)),
                  IconButton(
                      onPressed: _openSpendCreationModal,
                      icon: Icon(Icons.add)),
                ],
                body: Container(
                    child: ListView(
                        children: spendsController.spends
                            .where((spend) =>
                                categoriesController.pickedCategories.length ==
                                    0 ||
                                categoriesController
                                        .findByName(spend.category.name)
                                        ?.picked ==
                                    true)
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
