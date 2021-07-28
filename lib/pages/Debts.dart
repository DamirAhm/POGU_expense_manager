import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/Debts/DebtCreationModal.dart';
import 'package:test_app/components/Spends/CategoriesFilterModal.dart';
import 'package:test_app/components/Common/MyScaffold.dart';
import 'package:test_app/modules/models/Debt.dart';
import 'package:test_app/modules/services/AccountsController.dart';
import 'package:test_app/modules/services/CategoriesController.dart';
import 'package:test_app/modules/services/DebtsController.dart';

class DebtsPage extends StatefulWidget {
  DebtsPage({Key? key}) : super(key: key);

  @override
  _DebtsPageState createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  void _openNewDebtModal() {
    final debtsController =
        Provider.of<DebtsController>(context, listen: false);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return DebtEditingModal(
              onSubmit: (Debt newDebt) => debtsController.addDebt(newDebt));
        });
  }

  void _openDebtEditingModal(Debt debtToUpdate) {
    final debtsController = Provider.of<DebtsController>(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return DebtEditingModal(
            onSubmit: (Debt updatedDebt) =>
                debtsController.updateByName(debtToUpdate.name, updatedDebt),
            initialState: debtToUpdate,
            autoFocus: false,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DebtsController>(
        builder: (context, debtsController, child) => MyScaffold(
            title: 'Траты',
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: _openNewDebtModal,
              )
            ],
            body: Container(
                child: ListView(
                    children: ListTile.divideTiles(
                            context: context,
                            tiles: debtsController.debts
                                .map((debt) => DebtTile(debt))
                                .toList())
                        .toList()))));
  }
}

class DebtTile extends StatelessWidget {
  DebtTile(this._debt, {Key? key}) : super(key: key);

  final Debt _debt;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        title: Text(_debt.name),
        trailing: Text(_debt.amount.toString()),
      ),
    );
  }
}
