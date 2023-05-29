import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpBottomSheet extends StatefulWidget {
  const OtpBottomSheet({super.key});

  @override
  _OtpBottomSheetState createState() => _OtpBottomSheetState();
}

class _OtpBottomSheetState extends State<OtpBottomSheet> {
  String enteredOtp = '';

  @override
  Widget build(BuildContext context) {
    return Container(
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
              String otp = enteredOtp;
              // Add your OTP verification logic here

              // Close the bottom sheet
              Navigator.of(context).pop();
            },
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }
}
