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
  final bool isRegister;
  const LoginUserwithPhone({required this.mobile, required this.isRegister});
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

class RegisterVerifyOtp extends AuthEvent {
  final String verficationId;
  final String verficationCode;
  const RegisterVerifyOtp({
    required this.verficationCode,
    required this.verficationId,
  });
  @override
  List<Object> get props => [];
}

class LogOut extends AuthEvent {
  const LogOut();
  @override
  List<Object> get props => [];
}

class AddUserDetails extends AuthEvent {
  final String name;
  final String mobile;
  final String dob;
  final File image;
  final String email;
  const AddUserDetails({
    required this.dob,
    required this.email,
    required this.image,
    required this.mobile,
    required this.name,
  });
  @override
  List<Object> get props => [];
}
