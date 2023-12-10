part of 'auth_bloc.dart';

sealed class AuthState {}

class InitialAuthState implements AuthState {}

class AuthenticatedState implements AuthState {}

class LoadingAuthState implements AuthState {}

class ErrorAuthState extends AuthState {
  final String message;

  ErrorAuthState({required this.message});
}