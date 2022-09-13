

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user_data.dart';
import '../repositories/auth_repo.dart';

class LoginSignupUsecase {
  final AuthRepo authRepo;

  LoginSignupUsecase({required this.authRepo});

   Future<Either<Failure, Unit>> logInWithEmailAndPassword({required UserData userData}){
    return authRepo.logInWithEmailAndPassword(userData: userData);
   }
   Future<Either<Failure, Unit>> signUpWithEmailAndPassword({required UserData userData}){
    return authRepo.signUpWithEmailAndPassword(userData: userData);
   }
   Future<Either<Failure, Unit>> logInWithFacebook(){
    return authRepo.logInWithFacebook();
   }
   Future<Either<Failure, Unit>> logInWithGmail(){
    return authRepo.logInWithGmail();
   }
   Future<Either<Failure, Unit>> updatePassword({required UserData userData}){
    return authRepo.updatePassword(userData: userData);
   }
   Future<Either<Failure, Unit>> sendEmailLink({required UserData userData}){
    return authRepo.sendEmailLink(userData: userData);
   }
   Future<Either<Failure, Unit>> logOut(){
    return authRepo.logOut();
   }
}