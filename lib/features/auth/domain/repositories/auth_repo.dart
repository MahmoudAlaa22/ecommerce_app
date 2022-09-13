import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_data.dart';

abstract class AuthRepo {
  Future<Either<Failure, Unit>> logInWithEmailAndPassword(
      {required UserData userData});
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(
      {required UserData userData});
  Future<Either<Failure, Unit>> logInWithGmail();
  Future<Either<Failure, Unit>> logInWithFacebook();
  Future<Either<Failure, Unit>> verificationBySendEmail(
      {required UserData userData});
  Future<Either<Failure, Unit>> sendEmailLink({required UserData userData});
  Future<Either<Failure, Unit>> updatePassword({required UserData userData});
  Future<Either<Failure, Unit>> logOut();
  
}
