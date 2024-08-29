import 'dart:developer';
import 'package:easy_go/widget/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../consts/firebase_consts.dart';

class AuthController extends GetxController {
  String userUid = '';
  var verId = '';
  int? resendTokenId;
  bool phoneAuthCheck = false;
  UserCredential? userCredential;

  bool isValidPhoneNumber(String phoneNumber) {
    // Check if the phone number is a valid Indian mobile number with 10 digits
    return RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber);
  }

  phoneAuth(String phone) async {
    try {
      userCredential = null;
      await auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          log('Completed');
          userCredential = credential as UserCredential?;
          await auth.signInWithCredential(credential);
          currentUser = auth.currentUser;
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'Invalid phone number') {
            validSnackBar("The phone is not valid");
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          otpSnackBar("OTP sent successfully");
          log('Code sent');
          verId = verificationId;
          resendTokenId = resendToken;
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      log('Error $e');
    }
  }

  Future<void> verifyOtp(String otpNumber) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verId, smsCode: otpNumber);
      await auth.signInWithCredential(credential);
      currentUser = auth.currentUser;
      otpSnackBar("OTP verified successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveUserInfo(String name, String email, String phone) async {
    try {
      if (currentUser != null) {
        FirebaseMessaging fMessaging = FirebaseMessaging.instance;
        final fCMToken = await fMessaging.getToken();

        Map users = {
          'id': currentUser!.uid,
          'name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
          'fcmToken': fCMToken,
        };

        DatabaseReference database = FirebaseDatabase.instance.ref();

        await database.child('users').child(currentUser!.uid).set(users);

        successSnackBar("Account created successfully");
      } else {
        // Navigator.pop(context); // Close the dialog
        validSnackBar("Account has not been created");
      }
    } catch (e) {
      // Navigator.pop(context); // Close the dialog
      validSnackBar("Error saving user information: $e");
    }
  }

  Future<bool> checkUserDataExists(String phoneNumber) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

      DataSnapshot dataSnapshot = (await databaseReference
              .child('users')
              .orderByChild('phone')
              .equalTo(phoneNumber)
              .once())
          .snapshot;
      return dataSnapshot.value != null;
    } catch (error) {
      errorSnackBar('Error checking user data:', error);
      return false;
    }
  }

  logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      // Handle error, if any
      errorSnackBar("Error logging out", e);
    }
  }

validSnackBar(String message) {
  Get.snackbar(
    "Error",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFFD05045),
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
  );
}
}
