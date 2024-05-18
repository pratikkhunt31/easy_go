import 'package:easy_go/consts/firebase_consts.dart';
import 'package:easy_go/screens/login/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../widget/custom_widget.dart';

class LoginForm extends StatefulWidget {
  final String countryCode;
  final String phoneNumber;

  const LoginForm(this.countryCode, this.phoneNumber, {super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  AuthController authController = Get.put(AuthController());
  TextEditingController nameController = TextEditingController();

  // TextEditingController numController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void initState() {
    super.initState();
    // Check if a user is already logged in
    if (currentUser != null) {
      // If a user is logged in, navigate directly to the OTP screen
      navigateToOtpScreen();
    }
  }

  void navigateToOtpScreen() async {
    // Redirect to OTP screen
    await Get.off(
      () => OtpScreen(
        widget.countryCode + widget.phoneNumber,
        nameController.text.isNotEmpty ? nameController.text.trim() : null,
        emailController.text.isNotEmpty ? emailController.text.trim() : null,
      ),
    );
  }

  validate() async {
    if (nameController.text.isEmpty) {
      validSnackBar("Name is not empty");
    } else if (emailController.text.isEmpty) {
      validSnackBar("Email Address is not empty");
    // } else if (!emailController.text.contains("@gmail.com")) {
    //   validSnackBar("Email Address is not valid");
    } else {
      shareInfo();
    }
  }

  shareInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext c) {
        return ProgressDialog(message: "Processing, Please wait...");
      },
    );
    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
    await Get.to(
      () => OtpScreen(
        widget.countryCode + widget.phoneNumber,
        nameController.text.trim(),
        emailController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("${widget.countryCode}${widget.phoneNumber}");
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;

    Widget buildTop() {
      return SizedBox(
        width: screenWidth,
        child: Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.location_on_sharp,
                size: 40,
                color: Colors.white,
              ),
              Text(
                "Easy Go",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget buildForm() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Welcome",
            style: TextStyle(
              color: Color(0xFF000000),
              fontWeight: FontWeight.w500,
              fontSize: 32,
            ),
          ),
          const SizedBox(height: 10),
          const Text("Please Enter Your Correct Details"),
          const SizedBox(height: 20),
          buildTextFormField(
              controller: nameController, "Name", Icons.person_outline_sharp),
          const SizedBox(height: 20),
          buildTextFormField("Mobile", Icons.phone,
              sufIcon: Icons.edit, read: true, hint: widget.phoneNumber),
          const SizedBox(height: 20),
          buildTextFormField(
              controller: emailController, "Email", Icons.email_outlined),
          const SizedBox(height: 20),
          SizedBox(
            width: screenWidth,
            child: CustomButton(
              hint: "Continue",
              onPress: () {
                validate();
              },
              borderRadius: BorderRadius.circular(25.0),
              color: const Color(0xFF0000FF),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "A one time password (OTP) will sent to this mobile number.",
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    Widget buildBottom() {
      return Container(
        height: screenHeight / 1.67,
        width: screenWidth,
        padding: const EdgeInsets.only(top: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              right: 30.0, left: 30.0, bottom: 30.0, top: 10.0),
          child: buildForm(),
        ),
      );
    }

    return Container(
      color: const Color(0xFF0000FF).withOpacity(0.9),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(top: 70, child: buildTop()),
            Positioned(bottom: 0, child: buildBottom()),
          ],
        ),
      ),
    );
  }
}
