part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}
class AuthLoadingState extends AuthState {}
class AuthSuccessfulState extends AuthState {
final String message;
  const AuthSuccessfulState({required this.message});
}
class AuthErrorState extends AuthState {
final String message;

  const AuthErrorState({required this.message});

}
