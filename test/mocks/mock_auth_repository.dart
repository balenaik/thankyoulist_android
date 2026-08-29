import 'package:thankyoulist/models/user_model.dart';
import 'package:thankyoulist/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  String? getUserIdResult;
  Object? getUserIdError;
  @override
  Future<String> getUserId() async {
    final error = getUserIdError;
    if (error != null) throw error;
    return getUserIdResult ?? '';
  }

  UserModel? getUserResult;
  Object? getUserError;
  @override
  Future<UserModel> getUser() async {
    final error = getUserError;
    if (error != null) throw error;
    final user = getUserResult;
    if (user == null) throw UserNotFoundException();
    return user;
  }

  Object? logoutError;
  @override
  Future<void> logout() async {
    final error = logoutError;
    if (error != null) throw error;
  }

  int deleteAccountCallCount = 0;
  Object? deleteAccountError;
  @override
  Future<void> deleteAccount() async {
    deleteAccountCallCount++;
    final error = deleteAccountError;
    if (error != null) throw error;
  }
}
