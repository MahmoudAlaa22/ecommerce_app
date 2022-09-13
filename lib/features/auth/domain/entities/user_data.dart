import 'package:equatable/equatable.dart';

class UserData extends Equatable {
  final String? name;
  final String email;
  final String? password;

  const UserData({
    this.name,
    required this.email,
    this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}
