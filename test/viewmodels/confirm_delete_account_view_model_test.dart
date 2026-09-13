import 'package:flutter_test/flutter_test.dart';
import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/status.dart';
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

  group('registeredEmail', () {
    test('is empty and status is loadAuthInfoFailed when authRepository.getUser() throws', () async {
      final freshViewModel = ConfirmDeleteAccountViewModel(MockAuthRepository());

      await Future<void>.delayed(Duration.zero);

      expect(freshViewModel.registeredEmail, '');
      expect(freshViewModel.status, ConfirmDeleteAccountStatus.loadAuthInfoFailed);
    });

    test('reflects the email returned by authRepository.getUser() and status stays none', () async {
      const registeredEmail = 'registered@example.com';
      final authRepository = MockAuthRepository()
        ..getUserResult = UserModel(
          id: 'test-id',
          displayName: 'Test User',
          email: registeredEmail,
          photoUrl: '',
        );
      final freshViewModel = ConfirmDeleteAccountViewModel(authRepository);

      await Future<void>.delayed(Duration.zero);

      expect(freshViewModel.registeredEmail, registeredEmail);
      expect(freshViewModel.status, Status.none);
    });
  });

  group('deleteAccount', () {
    test('does not call authRepository.deleteAccount() when isDeleteButtonEnabled is false', () async {
      final authRepository = MockAuthRepository();
      final freshViewModel = ConfirmDeleteAccountViewModel(authRepository);
      freshViewModel.updateEmail('');

      await freshViewModel.deleteAccount();

      expect(authRepository.deleteAccountCallCount, 0);
    });

    test('does not call authRepository.deleteAccount() and sets status to emailMismatch when emailInput does not match registeredEmail', () async {
      final authRepository = MockAuthRepository()
        ..getUserResult = UserModel(
          id: 'test-id',
          displayName: 'Test User',
          email: 'registered@example.com',
          photoUrl: '',
        );
      final freshViewModel = ConfirmDeleteAccountViewModel(authRepository);
      await Future<void>.delayed(Duration.zero);
      freshViewModel.updateEmail('someone-else@example.com');

      await freshViewModel.deleteAccount();

      expect(authRepository.deleteAccountCallCount, 0);
      expect(freshViewModel.status, ConfirmDeleteAccountStatus.emailMismatch);
    });

    test('calls authRepository.deleteAccount() when emailInput matches registeredEmail', () async {
      const registeredEmail = 'registered@example.com';
      final authRepository = MockAuthRepository()
        ..getUserResult = UserModel(
          id: 'test-id',
          displayName: 'Test User',
          email: registeredEmail,
          photoUrl: '',
        );
      final freshViewModel = ConfirmDeleteAccountViewModel(authRepository);
      await Future<void>.delayed(Duration.zero);
      freshViewModel.updateEmail(registeredEmail);

      await freshViewModel.deleteAccount();

      expect(authRepository.deleteAccountCallCount, 1);
    });

    test('calls authRepository.deleteAccount() when emailInput matches registeredEmail case-insensitively', () async {
      const registeredEmail = 'registered@example.com';
      final authRepository = MockAuthRepository()
        ..getUserResult = UserModel(
          id: 'test-id',
          displayName: 'Test User',
          email: registeredEmail,
          photoUrl: '',
        );
      final freshViewModel = ConfirmDeleteAccountViewModel(authRepository);
      await Future<void>.delayed(Duration.zero);
      freshViewModel.updateEmail(registeredEmail.toUpperCase());

      await freshViewModel.deleteAccount();

      expect(authRepository.deleteAccountCallCount, 1);
  });

  group('clearStatus', () {
    test('resets status to none', () async {
      final authRepository = MockAuthRepository()
        ..getUserResult = UserModel(
          id: 'test-id',
          displayName: 'Test User',
          email: 'registered@example.com',
          photoUrl: '',
        );
      final freshViewModel = ConfirmDeleteAccountViewModel(authRepository);
      await Future<void>.delayed(Duration.zero);
      freshViewModel.updateEmail('someone-else@example.com');
      await freshViewModel.deleteAccount();

      freshViewModel.clearStatus();

      expect(freshViewModel.status, Status.none);
    });
  });
}
