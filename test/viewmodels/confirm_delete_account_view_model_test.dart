import 'package:flutter_test/flutter_test.dart';
import 'package:thankyoulist/viewmodels/confirm_delete_account_view_model.dart';

import '../mocks/mock_auth_repository.dart';

void main() {
  late ConfirmDeleteAccountViewModel viewModel;

  setUp(() {
    viewModel = ConfirmDeleteAccountViewModel(MockAuthRepository());
  });

  group('isDeleteButtonEnabled', () {
    test('is false when emailInput is empty', () {
      viewModel.updateEmail('');

      expect(viewModel.isDeleteButtonEnabled, isFalse);
    });

    test('is false when emailInput is not a valid email', () {
      viewModel.updateEmail('not-an-email');

      expect(viewModel.isDeleteButtonEnabled, isFalse);
    });

    test('is false when emailInput is missing a domain', () {
      viewModel.updateEmail('user@');

      expect(viewModel.isDeleteButtonEnabled, isFalse);
    });

    test('is true when emailInput is a valid email', () {
      viewModel.updateEmail('user@example.com');

      expect(viewModel.isDeleteButtonEnabled, isTrue);
    });
  });
}
