import 'dart:developer';

import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../domain/entities/user_data.dart';

abstract class AuthRemoteDataSource {
  Future<Unit> logInWithEmailAndPassword({required UserData userData});
  Future<Unit> signUpWithEmailAndPassword({required UserData userData});
  Future<Unit> logInWithGmail();
  Future<Unit> logInWithFacebook();
  Future<Unit> verificationBySendEmail({required UserData userData});
  Future<Unit> sendEmailLink({required UserData userData});
  Future<Unit> updatePassword({required UserData userData});
  Future<User> logOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({required this.firebaseAuth});

  /// **************************** With Email & Password ****************************///
  @override
  Future<Unit> logInWithEmailAndPassword({required UserData userData}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: userData.email.trim(), password: userData.password!.trim());
      return Future.value(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
        throw WrongPasswordException();
      } else {
        throw ServerException();
      }
    }
  }

  @override
  Future<Unit> signUpWithEmailAndPassword({required UserData userData}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: userData.email.trim(),
        password: userData.password!.trim(),
      );
      await verificationBySendEmail(userData: userData);
      return Future.value(unit);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      log('Error in auth remote data source impl in signUpWithEmailAndPassword error is $e');
      throw ServerException();
    }
  }

  /// ********************************** With Gmail **********************************///

  @override
  Future<Unit> logInWithGmail() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      log('userCredential.user.email is ${userCredential.user!.email}');
      log('userCredential.user.phoneNumber is ${userCredential.user!.phoneNumber}');
      return Future.value(unit);
    } catch (e) {
      throw GmailAuthException();
    }
  }

  /// ********************************** With Facebook **********************************///
  @override
  Future<Unit> logInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance
          .login(permissions: ["public_profile", "email"]);
      // await FacebookAuth.instance.getUserData();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      final userCredential =
          await firebaseAuth.signInWithCredential(facebookAuthCredential);
      log('userCredential.user!.email is ${userCredential.user!.email}');
      log('userCredential.user!.phoneNumber is ${userCredential.user!.phoneNumber}');
      return Future.value(unit);
    } catch (e) {
      log('Error in login facebook is ${e.toString()}');
      throw FacebookAuthException();
    }
  }

  /// ********************************** Send Email Link **********************************///

  @override
  Future<Unit> sendEmailLink({required UserData userData}) async {
    try {
      log('sendEmailLink in Start');
      var acs =  ActionCodeSettings(
          // URL you want to redirect back to. The domain (www.example.com) for this
          // URL must be whitelisted in the Firebase Console.
          url: 'https://ecommerce22.link.page/',
          // This must be true
          handleCodeInApp: true,
          // iOSBundleId: 'com.google.firebase.flutterauth',
          // androidPackageName: 'com.google.firebase.flutterauth',
          // installIfNotAvailable
          // androidInstallApp: true,
          );
      log('sendEmailLink after ActionCodeSettings');

      var emailAuth = 'mahmoud3laa2210@gmail.com';
      FirebaseAuth.instance
          .sendSignInLinkToEmail(email: emailAuth, actionCodeSettings: acs)
          .catchError(
              (onError) => log('Error sending email verification $onError'))
          .then((value) => log('Successfully sent email verification'));
          return Future.value(unit);
    } catch (e) {
      throw VerificationBySendEmailException();
    }
  }

  /// ********************************** Update Password **********************************///

  @override
  Future<Unit> updatePassword({required UserData userData}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: userData.email.trim());
      return Future.value(unit);
    } catch (e) {
      log('Error in updata password is $e');
      throw UpdatePasswordException();
    }
  }

  /// ***************************** Verification By Send Email *****************************///

  @override
  Future<Unit> verificationBySendEmail({required UserData userData}) async {
    try {
      await firebaseAuth.currentUser!.sendEmailVerification();
      log('firebaseAuth.currentUser!.emailVerified is ${firebaseAuth.currentUser!.emailVerified}');
      return Future.value(unit);
    } catch (e) {
      log('Error in verfication is $e');
      throw VerificationBySendEmailException();
    }
  }

  /// ********************************** Get CurrentUser **********************************///

  @override
  Future<User> logOut() {
    // TODO: implement getCurrentUser
    throw UnimplementedError();
  }
}
