import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/entities/user_data.dart';
import '../../../domain/usecases/login_signup_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/strings/failures.dart';
import '../../../../../core/strings/messags.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  // final LogInWithEmailAndPasswordUsecase logInEmailPasswordUsecase;
  // final SignUpWithEmailAndPasswordUsecase signUpEmailPasswordUsecase;
  // final LogInWithGmailUsecase logInWithGmailUsecase;
  // final LogInWithFacebookUsecase logInWithFacebookUsecase;
  // final UpdatePasswordUsecase updatePasswordUsecase;
  // final SendEmailLinkUsecase sendEmailLinkUsecase;
  final LoginSignupUsecase loginSignupUsecase;
  AuthCubit({
    // required this.logInEmailPasswordUsecase,
    // required this.signUpEmailPasswordUsecase,
    // required this.logInWithGmailUsecase,
    // required this.logInWithFacebookUsecase,
    // required this.updatePasswordUsecase,
    // required this.sendEmailLinkUsecase,
    // required this.verificationBySendEmailUsecase,
    required this.loginSignupUsecase
  }) : super(AuthInitial());
  static AuthCubit get(BuildContext context) => BlocProvider.of(context);

  // **************************** With Email & Password ****************************//
  Future<void> logInWithEmailAndPassword({required UserData userData}) async {
    final failureOrDone = await loginSignupUsecase.logInWithEmailAndPassword(userData:userData);
    emit(_mapFailuerOrDoneMessage(
        either: failureOrDone, message: LOG_IN_SUCCESS_MESSAGE));
  }

  Future<void> signUpWithEmailAndPassword({required UserData userData}) async {
    final failureOrDone = await loginSignupUsecase.signUpWithEmailAndPassword(userData:userData);
    emit(_mapFailuerOrDoneMessage(
        either: failureOrDone, message: SIGN_UP_SUCCESS_MESSAGE));
  }
  
  // ********************************** With Gmail **********************************//
  Future<void> loginWithGmail() async {
    final failureOrDone = await loginSignupUsecase.logInWithGmail();
    emit(_mapFailuerOrDoneMessage(
        either: failureOrDone, message: GMAIL_LOG_IN_SUCCESS_MESSAGE));
  }

  // ********************************** With Facebook **********************************//
  Future<void> loginWithFaceBook()async{
    final failureOrDone=await loginSignupUsecase.logInWithFacebook();
    emit(_mapFailuerOrDoneMessage(
        either: failureOrDone, message: FACEBOOK_LOG_IN_SUCCESS_MESSAGE));
  }


  // ********************************** Update Password **********************************//
  Future<void> updatePassword({required UserData userData})async{
    final failureOrDone=await loginSignupUsecase.updatePassword(userData:userData);
    emit(_mapFailuerOrDoneMessage(
        either: failureOrDone, message: UPDATA_PASSWORD_SUCCESS_MESSAGE));
  }
  Future<void> sendEmailLink({required UserData userData})async{
    final failureOrDone=await loginSignupUsecase.sendEmailLink(userData:userData);
    emit(_mapFailuerOrDoneMessage(
        either: failureOrDone, message: VERIFICATION_BY_EMAIL_SUCCESS_MESSAGE));
  }
  //! ******************************** Privet Method ********************************///
  AuthState _mapFailuerOrDoneMessage({
    required Either<Failure, Unit> either,
    required String message,
  }) {
    return either.fold(
        (failure) => AuthErrorState(message: _mapFailuerToMessage(failure)),
        (_) => AuthSuccessfulState(message: message));
  }

  String _mapFailuerToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case UserNotFoundFailure:
        return USER_NOT_FOUND_FAILURE_MESSAGE;
      case WrongPasswordFailure:
        return WRONG_PASSOWORD_FAILURE_MESSAGE;
      case VerificationBySendEmailFailure:
        return VERIFICATION_BY_EMAIL_FAILURE_MESSAGE;
      case GmailAuthFailure:
        return GMAIL_AUTH_FAILURE_MESSAGE;
      case FacebookAuthFailure:
        return FACEBOOK_AUTH_FAILURE_MESSAGE;
      case OfflineFailure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error ,Please try again later";
    }
  }
}
