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
  TextEditingController emailController = TextEditingController();

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
          padding: const EdgeInsets.only(top: 35.0),
          child: Image.asset(
            'assets/images/name.png',
            height: screenHeight * 0.2,
            width: double.infinity,
          ),
        ),
      );
    }

    Widget buildForm() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            "Welcome",
            style: TextStyle(
              color: Color(0xFF000000),
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * 0.08,
            ),
          ),
           SizedBox(height: screenHeight * 0.01),
          const Text("Please Enter Your Correct Details"),
          SizedBox(height: screenHeight * 0.02),
          buildTextFormField(
              controller: nameController, "Name", Icons.person_outline_sharp),
          SizedBox(height: screenHeight * 0.02),
          buildTextFormField("Mobile", Icons.phone,
              sufIcon: Icons.edit, read: true, hint: widget.phoneNumber),
          SizedBox(height: screenHeight * 0.02),
          buildTextFormField(
              controller: emailController, "Email", Icons.email_outlined),
          SizedBox(height: screenHeight * 0.02),
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
           SizedBox(height: screenHeight * 0.01),
          const Text(
            "A one time password (OTP) will sent to this mobile number.",
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    Widget buildBottom() {
      return Container(
        height: screenHeight / 1.76,
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
