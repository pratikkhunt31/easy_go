import 'dart:developer';
import 'package:easy_go/widget/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
        },
        forceResendingToken: resendTokenId,
        verificationFailed: (FirebaseAuthException e) {
          log('Failed');
          if (e.code == 'Invalid phone number') {
            print("The phone is not valid");
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

  // verifyOtp(String otpNumber) async {
  //   log("Called");
  //   PhoneAuthCredential credential =
  //       PhoneAuthProvider.credential(verificationId: verId, smsCode: otpNumber);
  //   log("loggedIn");
  //   await auth.signInWithCredential(credential);
  // }
  Future<void> verifyOtp(String otpNumber) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verId, smsCode: otpNumber);
      await auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  saveUserInfo(String name, String email, String phone) async {
    try {
      if (currentUser != null) {
        Map users = {
          'id': currentUser!.uid,
          'name': name.trim(),
          'email': email.trim(),
          'phone': phone.trim(),
        };

        DatabaseReference database = FirebaseDatabase.instance.ref();

        await database.child('users').child(currentUser!.uid).set(users);

        // Navigator.pop(context); // Close the dialog
        // Get.offAll(() => const HomeScreen());
        successSnackBar("Account created successfully");
      } else {
        // Navigator.pop(context); // Close the dialog
        validSnackBar("Account has not been created");
      }
    } catch (e) {
      // Navigator.pop(context); // Close the dialog
      validSnackBar("Error saving user information: $e");
    }

    // final User firebaseUser = (await auth.c);
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



// validSnackBar(String message) {
//   Get.snackbar(
//     "Error",
//     message,
//     snackPosition: SnackPosition.BOTTOM,
//     backgroundColor: const Color(0xFFD05045),
//     colorText: Colors.white,
//     borderRadius: 10,
//     margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
//   );
// }
}
