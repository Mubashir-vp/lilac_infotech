import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  logOutUser() async {
    log('arrived at is user Logout');
    try {
      await _auth.signOut().then(
            (value) => log('SignOut success'),
          );
    } catch (e) {
      log('Error occured $e');
      return null;
    }
  }

  checkUser(usersRef, phone) async {
    return await FirebaseFirestore.instance.runTransaction((transaction) async {
      final querySnapshot =
          await usersRef.where('phone', isEqualTo: phone).get();
      if (querySnapshot != null && querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<dynamic> signInWithPhoneNumber(
    String smsCode,
    String verificationId,
  ) async {
    final PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        return user;
      } else {
        return null;
      }

      // Perform additional operations with the signed-in user
      // Return the signed-in user
    } catch (e) {
      // Handle sign-in error
      return null;
    }
  }
}
