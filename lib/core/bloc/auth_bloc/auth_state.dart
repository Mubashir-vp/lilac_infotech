part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class LogedInState extends AuthState {
  final User user;
  const LogedInState({
    required this.user,
  });
  @override
  List<Object> get props => [user];
}

class LogedOutState extends AuthState {
  const LogedOutState();
  @override
  List<Object> get props => [];
}

class LoggingFailedState extends AuthState {
  final String errorMesage;
  const LoggingFailedState({required this.errorMesage});
  @override
  List<Object> get props => [];
}

class OtpSent extends AuthState {
  const OtpSent();
  @override
  List<Object> get props => [];
}
