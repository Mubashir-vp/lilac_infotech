import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../core/bloc/auth_bloc/auth_bloc.dart';
import '../view/home/home.dart';

class OtpBottomSheet extends StatefulWidget {
  const OtpBottomSheet(
      {super.key, required this.verificationId, required this.phone});
  final String verificationId;
  final String phone;
  @override
  _OtpBottomSheetState createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String enteredOtp = '';
  AuthBloc authBloc = AuthBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      bloc: authBloc,
      listener: (context, state) {
        if (state is LogedInState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => HomePage(
                    userModel: state.userModel,
                  )),
            ),
          );
        } else if (state is LogedOutState) {
          log('LogedOutState');
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter OTP',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                PinCodeTextField(
                  onCompleted: (value) {
                    log('state $state');
                    authBloc.add(
                      VerifyOtp(
                        verficationCode: value,
                        verficationId: widget.verificationId,
                      ),
                    );
                  },
                  appContext: context,
                  length: 6,
                  onChanged: (value) {
                    setState(() {
                      enteredOtp = value;
                    });
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.underline,
                    activeColor: Colors.blue,
                    inactiveColor: Colors.grey,
                    fieldHeight: 50,
                    fieldWidth: 40,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Verify the entered OTP
                    // String otp = enteredOtp;
                    // Add your OTP verification logic here

                    // Close the bottom sheet
                    Navigator.of(context).pop();
                  },
                  child: state is AuthLoading
                      ? const CircularProgressIndicator()
                      : const Text('Verify'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
