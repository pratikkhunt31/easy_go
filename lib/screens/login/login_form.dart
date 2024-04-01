import 'package:easy_go/screens/home/home_screen.dart';
import 'package:easy_go/screens/home_view.dart';
import 'package:easy_go/screens/login/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widget/custom_widget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenHeight = screenSize.height;
    final double screenWidth = screenSize.width;
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();

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
          const SizedBox(height: 30),
          buildTextFormField(
              nameController, "Name", Icons.person_outline_sharp),
          const SizedBox(height: 20),
          buildTextFormField(nameController, "Mobile", Icons.phone,
              sufIcon: Icons.edit),
          const SizedBox(height: 20),
          buildTextFormField(emailController, "Email", Icons.email_outlined),
          const SizedBox(height: 40),
          SizedBox(
            width: screenWidth,
            child: CustomButton(
              hint: "Continue",
              onPress: () {
                Get.to(() => const OtpScreen());
              },
              borderRadius: BorderRadius.circular(25.0),
              color: const Color(0xFF0000FF),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "A one time password (OTP) will sent to this mobile number",
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    Widget buildBottom() {
      return Container(
        height: screenHeight / 1.38,
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
            Positioned(top: 40, child: buildTop()),
            Positioned(bottom: 0, child: buildBottom()),
          ],
        ),
      ),
    );
  }
}
