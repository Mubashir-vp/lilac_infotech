part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LogedInState extends AuthState {
  final User user;
  final UserModel userModel;
  const LogedInState({required this.user, required this.userModel});
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

class RegistrationFailed extends AuthState {
  final String errorMesage;
  const RegistrationFailed({required this.errorMesage});
  @override
  List<Object> get props => [];
}

class NewUser extends AuthState {
  const NewUser();
  @override
  List<Object> get props => [];
}

class RegistrationSuccess extends AuthState {
  final UserModel userModel;
  const RegistrationSuccess({required this.userModel});
  @override
  List<Object> get props => [];
}

class OtpSent extends AuthState {
  final String verificationId;
  const OtpSent({required this.verificationId});
  @override
  List<Object> get props => [verificationId];
}

class RegisteredUser extends AuthState {
  const RegisteredUser();
  @override
  List<Object> get props => [];
}
