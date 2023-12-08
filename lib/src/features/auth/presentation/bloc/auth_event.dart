part of 'auth_bloc.dart';

sealed class AuthEvent {
  List<Object> get props => [];
}

class SignUpEvent implements AuthEvent {
  final String email;
  final String password;

  const SignUpEvent({
    required this.email,
    required this.password
  });

  @override
  List<Object> get props => [email, password];
}

class SignInEvent implements AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password
  });

  @override
  List<Object> get props => [email, password];
}
