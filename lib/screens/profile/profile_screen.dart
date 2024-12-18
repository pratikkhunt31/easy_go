import 'dart:developer';

import 'package:easy_go/screens/booking/bookings.dart';
import 'package:easy_go/screens/profile/edit_profile.dart';
import 'package:easy_go/screens/profile/privacy.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../consts/firebase_consts.dart';
import '../../controller/auth_controller.dart';
import '../../widget/custom_widget.dart';
import '../login/num_screen.dart';
import 'contact_detail.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool isLoading = true;
  String appVersion = "";

  final List locale = [
    {'name': 'English', 'locale': Locale('en', 'US')},
    {'name': 'Gujarati', 'locale': Locale('gu', 'IN')},
  ];

  @override
  void initState() {
    super.initState();
    loadUserData();
    loadAppVersion();
    loadLanguageFromPreferences();
  }

  Future<void> loadUserData() async {
    if (currentUser != null) {
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('users')
          .child(currentUser!.uid);
      DataSnapshot snapshot = await userRef.get();
      if (snapshot.exists && mounted) {
        Map<String, dynamic> userData =
            Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          nameController.text = userData['name'];
          emailController.text = userData['email'];
          isLoading = false;
        });
      }
    }
  }

  Future<void> loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  void showEditProfileBottomSheet() {
    Get.bottomSheet(
      Container(
        // height: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit Profile",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.grey),
                  fillColor: Color(0xFF0000FF),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0000FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF0000FF),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0000FF),
                ),
                onPressed: () async {
                  // Update user data in the database
                  if (currentUser != null) {
                    DatabaseReference userRef = FirebaseDatabase.instance
                        .ref()
                        .child('users')
                        .child(currentUser!.uid);
                    await userRef.update({
                      'name': nameController.text,
                      'email': emailController.text,
                    });
                    // Update the UI
                    setState(() {});
                    // Close the bottom sheet
                    Get.back();
                  }
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            title: Text('Choose a language'),
            content: Container(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: EdgeInsets.all(8.0),
                        child: GestureDetector(
                            onTap: () {
                              log('select language is: ${locale[index]['name']}');
                              updateLanguage(locale[index]['locale']);
                            },
                            child: Text(locale[index]['name'])));
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  Future<void> saveLanguageToPreferences(Locale locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    await prefs.setString('countryCode', locale.countryCode ?? '');
  }

  Future<void> loadLanguageFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('languageCode');
    String? countryCode = prefs.getString('countryCode');

    if (languageCode != null) {
      Locale savedLocale =
          Locale(languageCode, countryCode!.isNotEmpty ? countryCode : null);
      Get.updateLocale(savedLocale);
    }
  }

  updateLanguage(Locale locale) {
    Get.back();
    saveLanguageToPreferences(locale);
    Get.updateLocale(locale);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'account'.tr,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        backgroundColor: const Color(0xFF0000FF),
        elevation: 0,
      ),
      body: isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Color(0xFF0000FF),
                size: 50.0,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text(
                    //   "Setting",
                    //   style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    // ),
                    // const SizedBox(height: 10),
                    // const Text(
                    //   "Account",
                    //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    // ),
                    // const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF0000FF),
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(
                                20), // Adjust the padding as needed
                            child: Text(
                              nameController.text.isNotEmpty
                                  ? nameController.text[0]
                                  : '',
                              style: TextStyle(
                                fontSize: 24,
                                // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                // Optional: make the text bold
                                color: Colors
                                    .white, // Adjust the text color as needed
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nameController.text.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "personalInfo".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          ForwardIcon(
                            onTap: () {
                              showEditProfileBottomSheet();
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Text(
                      'settings'.tr,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 20),

                    SettingItem(
                      title: "yourBookings".tr,
                      icon: Ionicons.receipt_sharp,
                      bgColor: Colors.red.shade100,
                      iconColor: Colors.red,
                      onTap: () {
                        Get.to(() => Bookings());
                      },
                    ),
                    const SizedBox(height: 20),
                    SettingItem(
                      title: "privacyPolicy".tr,
                      icon: Icons.privacy_tip,
                      bgColor: Colors.blue.shade100,
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: PrivacyPolicy(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SettingItem(
                      title: "helpSupport".tr,
                      icon: Ionicons.help,
                      bgColor: Colors.green.shade100,
                      iconColor: Colors.green,
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            child: ContactDetailsPage(),
                            type: PageTransitionType.bottomToTop,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    SettingItem(
                      title: "lang".tr,
                      icon: Ionicons.language,
                      bgColor: Colors.red.shade100,
                      iconColor: Colors.red,
                      onTap: () {
                        buildDialog(context);
                      },
                    ),
                    const SizedBox(height: 20),
                    SettingItem(
                      title: "logOut".tr,
                      icon: Ionicons.log_out_sharp,
                      bgColor: Colors.red.shade100,
                      iconColor: Colors.red,
                      onTap: () async {
                        try {
                          print("logout");
                          await authController.logout();
                          Get.offAll(() => NumberScreen());
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "appVersion".tr,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            appVersion,
                            style: const TextStyle(
                              fontSize: 14,
                              // fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
