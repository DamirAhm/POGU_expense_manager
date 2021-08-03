import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/components/Debts/DebtEditingModal.dart';
import 'package:test_app/components/Common/MyScaffold.dart';
import 'package:test_app/modules/models/Account.dart';
import 'package:test_app/modules/models/Debt.dart';
import 'package:test_app/modules/services/AccountsController.dart';
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
    final accountsController =
        Provider.of<AccountsController>(context, listen: false);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return DebtEditingModal(onSubmit: (Debt newDebt) {
            debtsController.addDebt(newDebt);
            Account? debtAccount = newDebt.account;

            if (debtAccount != null) {
              int diff;
              if (newDebt.type == DebtType.lend) {
                diff = -newDebt.amount;
              } else if (newDebt.type == DebtType.owe) {
                diff = newDebt.amount;
              } else {
                throw new TypeError();
              }
              accountsController.changeAmountByName(debtAccount.name,
                  diff: diff);
            }
          });
        });
  }

  void _openDebtEditingModal(Debt debtToUpdate) {
    final debtsController =
        Provider.of<DebtsController>(context, listen: false);
    final accountsController =
        Provider.of<AccountsController>(context, listen: false);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return DebtEditingModal(
            onSubmit: (Debt updatedDebt) {
              debtsController.updateByName(debtToUpdate.name, updatedDebt);
              Account? debtAccount = updatedDebt.account;

              if (debtAccount != null) {
                int diff = debtToUpdate.amount - updatedDebt.amount;

                if (diff != 0) {
                  accountsController.changeAmountByName(debtAccount.name,
                      diff: diff);
                }
              }
            },
            initialState: debtToUpdate,
            autoFocus: false,
            isEditing: true,
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
                                .map((debt) => DebtTile(
                                    debt, () => _openDebtEditingModal(debt)))
                                .toList())
                        .toList()))));
  }
}

class DebtTile extends StatelessWidget {
  DebtTile(this._debt, this._onPressed, {Key? key}) : super(key: key);

  final Debt _debt;
  final void Function() _onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: _onPressed,
        title: Text(_debt.name),
        trailing: Text(_debt.amount.toString()),
      ),
    );
  }
}
