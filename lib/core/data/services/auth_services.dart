import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> isUserSignedIn() async {
    log('arrived at is user SignedIn');
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return null;
      } else {
        return user;
      }
    } catch (e) {
      log('Error occured $e');
      return null;
    }
  }

  Future<void> signInWithPhoneNumber(String smsCode, verificationId) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId!,
      smsCode: smsCode,
    );
    try {
      await _auth.signInWithCredential(credential);
      // Perform additional operations after successful sign-in
    } catch (e) {
      // Handle sign-in error
    }
  }
}
