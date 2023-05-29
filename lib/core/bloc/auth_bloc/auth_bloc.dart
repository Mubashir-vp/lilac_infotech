import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilac_info_tech/core/data/services/auth_services.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckUser>((event, emit) async {
      log('Arrived at bloc');
      var user = await AuthServices().isUserSignedIn();
      if (user == null) {
        log('Null case');
        emit(const LogedOutState());
        log('Logging for state $state');
      } else {
        log('Not null case');
        emit(LogedInState(user: user));
        log('Logging for state $state');
      }
    });

    on<LoginUserwithPhone>((event, emit) async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      emit(const OtpSent());
      await auth.verifyPhoneNumber(
        phoneNumber: event.mobile,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          emit(LoggingFailedState(errorMesage: e.toString()));
        },
        codeSent: (String verificationId, int? resendToken) {
          verificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
        },
      );
    });
  }
}
