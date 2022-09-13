import '../../../../core/error/exceptions.dart';
import '../datasources/auth_remote_data_source.dart';
import '../../domain/entities/user_data.dart';
import '../../../../core/error/failures.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource authRemoteDataSource;

  const AuthRepoImpl({required this.authRemoteDataSource});

  /// **************************** With Email & Password ****************************///
  @override
  Future<Either<Failure, Unit>> logInWithEmailAndPassword(
      {required UserData userData}) async {
    try {
      final failureOrDone = await authRemoteDataSource
          .logInWithEmailAndPassword(userData: userData);
      return Right(failureOrDone);
    } on ServerException {
      return Left(ServerFailure());
    } on UserNotFoundException {
      return Left(UserNotFoundFailure());
    } on WrongPasswordException {
      return Left(WrongPasswordFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> signUpWithEmailAndPassword(
      {required UserData userData}) async {
    try {
      final failureOrDone = await authRemoteDataSource
          .signUpWithEmailAndPassword(userData: userData);
      return Right(failureOrDone);
    } on ServerException {
      return Left(ServerFailure());
    } on WeakPasswordException {
      return Left(WeakPasswordFailure());
    } on EmailAlreadyInUseException {
      return Left(EmailAlreadyInUseFailure());
    }
  }

  /// ********************************** With Gmail **********************************///

  @override
  Future<Either<Failure, Unit>> logInWithGmail() async {
    try {
      final failureOrDone = await authRemoteDataSource.logInWithGmail();
      return Right(failureOrDone);
    } on GmailAuthException {
      return Left(GmailAuthFailure());
    }
  }

  /// ********************************** With Facebook **********************************///

  @override
  Future<Either<Failure, Unit>> logInWithFacebook()async {
  try {
      final failureOrDone = await authRemoteDataSource.logInWithFacebook();
      return Right(failureOrDone);
    } on FacebookAuthException {
      return Left(FacebookAuthFailure());
    }
  }

  /// ********************************** Send Email Link **********************************///

  @override
  Future<Either<Failure, Unit>> sendEmailLink({required UserData userData})async {
   try {
      final failureOrDone = await authRemoteDataSource.sendEmailLink(userData: userData);
      return Right(failureOrDone);
    } on VerificationBySendEmailException {
      return Left(VerificationBySendEmailFailure());
    }
  }

  /// ********************************** Update Password **********************************///

  @override
  Future<Either<Failure, Unit>> updatePassword({required UserData userData})async {
 try {
      final failureOrDone = await authRemoteDataSource.updatePassword(userData: userData);
      return Right(failureOrDone);
    } on UpdatePasswordException {
      return Left(UpdatePasswordFailure());
    }
  }

  /// ***************************** Verification By Send Email *****************************///

  @override
  Future<Either<Failure, Unit>> verificationBySendEmail(
      {required UserData userData}) async{
  try {
      final failureOrDone = await authRemoteDataSource.verificationBySendEmail(userData: userData);
      return Right(failureOrDone);
    } on VerificationBySendEmailException {
      return Left(VerificationBySendEmailFailure());
    }
  }

  /// ********************************** Get CurrentUser **********************************///

  @override
  Future<Either<Failure, User>> getCurrentUser() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
  
  @override
  Future<Either<Failure, Unit>> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }
}
