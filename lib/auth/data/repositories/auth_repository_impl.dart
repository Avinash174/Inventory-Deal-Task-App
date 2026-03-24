import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final SharedPreferences sharedPreferences;
  static const String keyEmail = 'LOGGED_IN_USER_EMAIL';
  static const String keyName = 'LOGGED_IN_USER_NAME';

  AuthRepositoryImpl({required this.sharedPreferences});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      
      if (email.isEmpty || password.length < 6) {
        return const Left(ServerFailure('Invalid email or password.'));
      }
      
      // Mock: Retrieve name if exists, else use email part
      final String? existingName = sharedPreferences.getString(keyName);
      final String name = existingName ?? email.split('@')[0];
      
      await sharedPreferences.setString(keyEmail, email);
      await sharedPreferences.setString(keyName, name);
      
      return Right(User(email: email, name: name));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signup(String email, String password, String name) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1200));
      
      if (email.isEmpty || password.length < 6 || name.isEmpty) {
        return const Left(ServerFailure('Please fill all fields correctly.'));
      }
      
      await sharedPreferences.setString(keyEmail, email);
      await sharedPreferences.setString(keyName, name);
      
      return Right(User(email: email, name: name));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await sharedPreferences.remove(keyEmail);
      await sharedPreferences.remove(keyName);
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final String? email = sharedPreferences.getString(keyEmail);
      final String? name = sharedPreferences.getString(keyName);
      
      if (email != null && name != null) {
        return Right(User(email: email, name: name));
      }
      return const Left(CacheFailure('No user session.'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
