import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/userModel.dart';

class FirebaseServices {
  Future<String> uploadImageToFirebaseStorage(
      File imageFile, String imageName) async {
    final Reference storageRef =
        FirebaseStorage.instance.ref().child('user_images/$imageName');
    final TaskSnapshot storageSnapshot = await storageRef.putFile(imageFile);
    if (storageSnapshot.state == TaskState.success) {
      final String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    }
    return '';
  }

  Future<void> saveUserDetailsToFirestore(String name, String email, String dob,
      String imageUrl, String phone) async {
    final CollectionReference usersRef =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userDocRef =
        usersRef.doc(); // Generate a new document ID

    await userDocRef.set(
        {
          'name': name,
          'email': email,
          'dob': dob,
          'id': userDocRef,
          'imageUrl': imageUrl,
          'phone': '+91$phone'
        },
        SetOptions(
          merge: true,
        )).timeout(const Duration(seconds: 60));
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

  addUserDetails(String name, String email, String dob, File imageFile,
      String phone) async {
    try {
      final CollectionReference usersRef =
          FirebaseFirestore.instance.collection('users');
      bool isUserExist = await checkUser(
        usersRef,
        phone,
      );
      log('message$isUserExist');
      if (!isUserExist) {
        final String imageName =
            DateTime.now().microsecondsSinceEpoch.toString();
        final String imageUrl =
            await uploadImageToFirebaseStorage(imageFile, imageName);
        await saveUserDetailsToFirestore(name, email, dob, imageUrl, phone);
        return 'true';
      } else {
        return 'Phone number already registered';
      }
    } catch (e) {
      log('Error caught in addUserDetails $e');
      return e.toString();
      // Handle errors
    }
  }

  Future<UserModel?> getUserDetailsFromFirestore(String phoneNumber) async {
    try {
      final collectionRef = FirebaseFirestore.instance.collection('users');
      log('Checking phone $phoneNumber');
      final querySnapshot =
          await collectionRef.where('phone', isEqualTo: phoneNumber).get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        final data = doc.data();
        return UserModel(
          dob: data['dob'],
          email: data['email'],
          imageLink: data['imageUrl'],
          name: data['name'],
          phone: data['phone'],
        );
      } else {
        log('No user found with the given phone number');
        return null;
      }
    } catch (e) {
      log('Error retrieving user details from Firestore: $e');
    }
    return null;
  }
}
