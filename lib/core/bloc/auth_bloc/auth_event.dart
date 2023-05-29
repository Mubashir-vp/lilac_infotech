part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckUser extends AuthEvent {
  @override
  List<Object> get props => [];
}

class LoginUserwithPhone extends AuthEvent {
  final String mobile;
  const LoginUserwithPhone({
    required this.mobile,
  });
  @override
  List<Object> get props => [];
}

class VerifyOtp extends AuthEvent {
  final String verficationId;
  final String verficationCode;
  const VerifyOtp({
    required this.verficationCode,
    required this.verficationId,
  });
  @override
  List<Object> get props => [];
}
