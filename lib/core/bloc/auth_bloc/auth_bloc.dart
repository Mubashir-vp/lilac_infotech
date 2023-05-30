// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lilac_info_tech/core/data/services/auth_services.dart';
import 'package:lilac_info_tech/core/data/services/firebase_services.dart';

import '../../data/model/userModel.dart';

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
        UserModel? userModel = await FirebaseServices()
            .getUserDetailsFromFirestore(user.phoneNumber!);
        if (userModel != null) {
          emit(
            LogedInState(
              user: user,
              userModel: userModel,
            ),
          );
        } else {
          emit(const LogedOutState());
        }
        log('Logging for state $state');
      }
    });

    void handleCodeSent(Emitter<AuthState> emit, String verificationId,
        Completer<void> completer, bool isCompleted) {
      if (!isCompleted) {
        emit(OtpSent(verificationId: verificationId));
        completer.complete(); // Complete the Completer in the handler method
      }
    }

    on<LoginUserwithPhone>((event, emit) async {
      emit(AuthLoading());
      if (!event.isRegister) {
        
        final CollectionReference usersRef =
            FirebaseFirestore.instance.collection('users');
        bool isUserExist = await AuthServices().checkUser(
          usersRef,
          '+91${event.mobile}',
        );
        if (isUserExist) {
          final Completer<void> completer =
              Completer<void>(); // Create a Completer
          final FirebaseAuth auth = FirebaseAuth.instance;
          bool isCompleted = false;
          await auth.verifyPhoneNumber(
            phoneNumber: '+91${event.mobile}',
            verificationCompleted: (PhoneAuthCredential credential) async {
              await auth.signInWithCredential(credential);
              isCompleted = true;
              completer
                  .complete(); // Complete the Completer when verification is completed
            },
            verificationFailed: (FirebaseAuthException e) {
              log('Verification failed: $e');
              emit(LoggingFailedState(errorMesage: e.toString()));
              isCompleted = true; // Set the completion flag to true
              completer.complete(); // Complete the Completer on failure as well
            },
            codeSent: (String verificationId, int? resendToken) {
              handleCodeSent(emit, verificationId, completer,
                  isCompleted); // Pass the Completer to the handler method
              log('Verification code sent: $verificationId');
              // verificationId = verificationId;
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              // verificationId = verificationId;
            },
          );

          await completer
              .future; // Await the completion of the asynchronous operation
        } else {
          emit(const NewUser());
        }
      } else {
        final Completer<void> completer =
            Completer<void>(); // Create a Completer
        final FirebaseAuth auth = FirebaseAuth.instance;
        bool isCompleted = false;
        await auth.verifyPhoneNumber(
          phoneNumber: '+91${event.mobile}',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await auth.signInWithCredential(credential);
            isCompleted = true;
            completer
                .complete(); // Complete the Completer when verification is completed
          },
          verificationFailed: (FirebaseAuthException e) {
            log('Verification failed: $e');
            emit(LoggingFailedState(errorMesage: e.toString()));
            isCompleted = true; // Set the completion flag to true
            completer.complete(); // Complete the Completer on failure as well
          },
          codeSent: (String verificationId, int? resendToken) {
            handleCodeSent(emit, verificationId, completer,
                isCompleted); // Pass the Completer to the handler method
            log('Verification code sent: $verificationId');
            // verificationId = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // verificationId = verificationId;
          },
        );

        await completer
            .future; // Await the completion of the asynchronous operation
      }
    });
    on<VerifyOtp>((event, emit) async {
      var user = await AuthServices().signInWithPhoneNumber(
        event.verficationCode,
        event.verficationId,
      );
      log('$user');
      if (user != null) {
        UserModel? userModel = await FirebaseServices()
            .getUserDetailsFromFirestore(user.phoneNumber!);
        if (userModel != null) {
          emit(
            LogedInState(
              user: user,
              userModel: userModel,
            ),
          );
        } else {
          emit(const LogedOutState());
        }

        log('State checking $state');
      } else {
        emit(
          const LoggingFailedState(
            errorMesage: 'Login Failed',
          ),
        );
      }
    });
    on<RegisterVerifyOtp>((event, emit) async {
      var user = await AuthServices().signInWithPhoneNumber(
        event.verficationCode,
        event.verficationId,
      );
      log('$user');
      if (user != null) {
        emit(const RegisteredUser());
        log('State checking $state');
      } else {
        emit(
          const LoggingFailedState(
            errorMesage: 'Login Failed',
          ),
        );
      }
    });
    on<LogOut>((event, emit) async {
      log('LoggedOut Called');
      await AuthServices().logOutUser();
      emit(
        const LogedOutState(),
      );
    });
    on<AddUserDetails>((event, emit) async {
      emit(AuthLoading());
      log('Add user details Called');
      String isSuccess = await FirebaseServices().addUserDetails(
        event.name,
        event.email,
        event.dob,
        event.image,
        event.mobile,
      );
      log('Is success $isSuccess');
      if (isSuccess == 'true') {
        log('Resistration success');
        UserModel? userModel = await FirebaseServices()
            .getUserDetailsFromFirestore('+91${event.mobile}');
        if (userModel != null) {
          emit(RegistrationSuccess(userModel: userModel));
        } else {
          emit(const LogedOutState());
        }
      } else if (isSuccess == null) {
        AuthServices().logOutUser();
        emit(
          const RegistrationFailed(
              errorMesage: 'Registration failed please try again'),
        );
      } else {
        AuthServices().logOutUser();
        emit(
          RegistrationFailed(errorMesage: isSuccess),
        );
      }
    });
  }
}
