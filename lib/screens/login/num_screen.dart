import 'package:country_picker/country_picker.dart';

import 'package:easy_go/screens/login/login_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../widget/custom_widget.dart';
import 'login_otp.dart';

class NumberScreen extends StatefulWidget {
  const NumberScreen({super.key});

  @override
  State<NumberScreen> createState() => _NumberScreenState();
}

class _NumberScreenState extends State<NumberScreen> {
  final TextEditingController phoneController = TextEditingController();
  AuthController authController = Get.put(AuthController());

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  void _checkUserDataAndNavigate() async {
    bool userDataExists = await authController.checkUserDataExists(
        "+${selectedCountry.phoneCode + phoneController.text.trim()}");
    if (userDataExists) {
      // User data exists, navigate to OTP screen
      Get.to(() => LoginOtp(
          "+${selectedCountry.phoneCode}" + phoneController.text.trim()));
    } else {
      // User data doesn't exist, navigate to login form
      Get.to(() => LoginForm(
          "+${selectedCountry.phoneCode}", phoneController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length));
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                    minWidth: constraints.maxWidth,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: constraints.maxHeight * 0.03,
                      horizontal: constraints.maxWidth * 0.05,
                    ),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          // height: constraints.maxHeight * 0.42,
                          width: constraints.maxWidth * 0.8,
                          child: Image.asset(
                            'assets/images/number.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.01),
                        Text(
                          "Let's get started",
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.01),
                        Text(
                          "Enter your valid phone number. We'll send you a verification code",
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                            color: Colors.black45,
                            // fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.022),
                        TextFormField(
                          cursorColor: Colors.blue,
                          controller: phoneController,
                          // maxLength: 10,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              phoneController.text = value;
                            });
                          },
                          style: TextStyle(
                            fontSize: constraints.maxWidth * 0.04,
                          ),
                          decoration: InputDecoration(
                            hintText: "Enter Phone Number",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: constraints.maxWidth * 0.04,
                              color: Colors.grey.shade600,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                              borderSide: const BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            prefixIcon: Container(
                              padding: const EdgeInsets.only(
                                top: 13.0,
                                left: 8,
                                right: 5,
                              ),
                              child: InkWell(
                                onTap: () {
                                  // showCountryPicker(
                                  //   context: context,
                                  //   countryListTheme:
                                  //       const CountryListThemeData(
                                  //     bottomSheetHeight: 400,
                                  //   ),
                                  //   onSelect: (value) => {
                                  //     setState(() {
                                  //       selectedCountry = value;
                                  //     })
                                  //   },
                                  // );
                                },
                                child: Text(
                                  "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            suffixIcon: phoneController.text.length.isEqual(10)
                                ? Container(
                                    height: 28,
                                    width: 28,
                                    margin: const EdgeInsets.all(10.0),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green,
                                    ),
                                    child: const Icon(
                                      Icons.done,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        SizedBox(
                          width: double.infinity,
                          height: constraints.maxHeight * 0.065,
                          child: CustomButton(
                            hint: "Login",
                            color: phoneController.text.length.isEqual(10)
                                ? const Color(0xFF0000FF)
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(25.0),
                            onPress: phoneController.text.length.isEqual(10)
                                ? () async {
                                    try {
                                      await Future.delayed(
                                          const Duration(seconds: 2));
                                      // if (!authController.isValidPhoneNumber(
                                      //     phoneController.text)) {
                                      //   // Show an error Snack bar if the phone number is invalid
                                      //   authController.validSnackBar(
                                      //       "Invalid phone number. Please enter a valid 10-digit number.");
                                      //   return;
                                      // }
                                      // Proceed with login

                                      _checkUserDataAndNavigate();
                                      // print(
                                      //     "+${selectedCountry.phoneCode + phoneController.text.trim()}");
                                    } catch (e) {
                                      validSnackBar(
                                          "Error validating phone number: $e");
                                    }
                                  }
                                : () {},
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.025),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: constraints.maxWidth * 0.05),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: constraints.maxWidth * 0.035),
                              children: const [
                                TextSpan(
                                    text:
                                        "By creating an account, you agree to our"
                                        " "),
                                TextSpan(
                                  text: "Terms of Service ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "and ",
                                  // style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "Privacy Policy",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
