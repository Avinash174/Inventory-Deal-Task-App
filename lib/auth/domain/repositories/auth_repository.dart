import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> signup(String email, String password, String name);
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, User>> getCurrentUser();
}

class User extends Equatable {
  final String email;
  final String name;
  const User({required this.email, required this.name});

  @override
  List<Object?> get props => [email, name];
}
