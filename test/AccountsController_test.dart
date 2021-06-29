import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/modules/services/AccountsController.dart';

void main() {
  group("Accounts Controller", () {
    test('Accounts controller creates with empty accounts', () {
      final accountsController = AccountsController();

      expect(accountsController.accounts.length, equals(0));
    });
  });
}
