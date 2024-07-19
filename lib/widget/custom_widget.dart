import 'package:easy_go/screens/login/num_screen.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:velocity_x/velocity_x.dart';

Widget CustomButton({
  required String hint,
  required Function onPress,
  Color? color,
  required BorderRadius borderRadius,
}) {

  const buttonHeight = 50.0; // You can adjust the height according to your preference
  const fontSize = buttonHeight * 0.38; // Adjust font size relative to button height

  return SizedBox(
    height: buttonHeight,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: borderRadius,
      child: EasyButton(
        type: EasyButtonType.elevated,
        onPressed: onPress as void Function()?,
        buttonColor: color ?? const Color(0xFF0000FF),
        idleStateWidget: Text(
          hint,
          style: TextStyle(
            fontSize: fontSize,
          ),
        ),
        loadingStateWidget: const CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        ),
        useWidthAnimation: false,
        useEqualLoadingStateWidgetDimension: true,
        height: 45,
        elevation: 0.0,
        contentGap: 5.1,
      ),
    ),
  );
}


class CustomButton1 extends StatelessWidget {
  final String? hint;
  final Function onPress;
  final Color? color;
  final BorderRadius borderRadius;

  const CustomButton1(
      {super.key,
      required this.hint,
      required this.onPress,
      this.color,
      required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final buttonWidth = constraints.maxWidth * 0.8;
        const buttonHeight = 50.0;
        const fontSize = buttonHeight * 0.38;

        return SizedBox(
          height: buttonHeight,
          width: buttonWidth,
          child: ClipRRect(
            borderRadius: borderRadius,
            child: EasyButton(
              type: EasyButtonType.elevated,
              onPressed: onPress as void Function()?,
              buttonColor: const Color(0xFF0000FF),
              idleStateWidget: Text(
                hint!,
                style: const TextStyle(
                  fontSize: fontSize,
                ),
              ),
              loadingStateWidget: const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
              ),
              useWidthAnimation: false,
              useEqualLoadingStateWidgetDimension: true,
              // width: 150,
              height: 45,
              elevation: 0.0,
              contentGap: 5.1,
            ),
          ),
        );
      },
    );
  }
}

class VehicleCard extends StatelessWidget {
  final String vName;
  final String image;
  final double height;
  final Function() onPress;

  VehicleCard({
    super.key,
    required this.vName,
    required this.image,
    required this.onPress,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 150,
                    child: Center(
                      child: Image.asset(
                        image,
                        height: height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(7.0),
                        child: Text(
                          vName,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          onPress();
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'Book for your delivery',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

TextFormField buildTextFormField(String fieldName, IconData icon,
    {TextEditingController? controller,
    IconData? sufIcon,
    bool? read = false,
    String? hint}) {
  return TextFormField(
    initialValue: hint,
    controller: controller,
    cursorColor: Colors.black,
    readOnly: read != true ? false : true,
    decoration: InputDecoration(
      labelText: fieldName,
      labelStyle: const TextStyle(color: Colors.black),
      border: const OutlineInputBorder(borderSide: BorderSide()),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      prefixIcon: Icon(
        icon,
        color: Colors.black,
      ),
      suffixIcon: sufIcon != null
          ? IconButton(
              icon: Icon(sufIcon),
              onPressed: () {
                Get.off(const NumberScreen());
              },
            )
          : null,
    ),
  );
}

class ForwardIcon extends StatelessWidget {
  final Function() onTap;

  const ForwardIcon({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(
          Ionicons.chevron_forward_outline,
          size: 30,
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final String? value;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function() onTap;

  const SettingItem({
    super.key,
    required this.title,
    this.value,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Icon(
              icon,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          value != null
              ? Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 15),
          ForwardIcon(
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class EditItem extends StatelessWidget {
  final String title;
  final Widget widget;

  const EditItem({
    super.key,
    required this.widget,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
        // const SizedBox(width: 30),
        Expanded(
          flex: 5,
          child: widget,
        ),
      ],
    );
  }
}

class ProgressDialog extends StatelessWidget {
  final String message;

  ProgressDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // backgroundColor: Colors.black,
      elevation: 0.0,
      child: Container(
        margin: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(width: 6),
              const CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0000FF)),
              ),
              const SizedBox(width: 15),
              Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

successSnackBar(String message) {
  Get.snackbar(
    "Successfully Logged in",
    message,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFF2EC492),
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
  );
}

errorSnackBar(String message, _) {
  Get.snackbar(
    "Error",
    "$message\n${_.message}",
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: const Color(0xFFD05045),
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
  );
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

otpSnackBar(String message) {
  Get.snackbar(
    "Verification",
    message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: const Color(0xFF2EC492),
    colorText: Colors.white,
    borderRadius: 10,
    margin: const EdgeInsets.only(top: 20, left: 10, right: 10),
  );
}

Widget exitDialog(context) {
  return Dialog(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Confirm?",
          style: TextStyle(fontSize: 16),
        ),
        Divider(),
        SizedBox(height: 10),
        Text(
          "Are you sure want to exit",
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0000FF),
                padding: EdgeInsets.all(12),
              ),
              onPressed: () {
                SystemNavigator.pop();
              },
              child: "Yes".text.color(Colors.white).make(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0000FF),
                padding: EdgeInsets.all(12),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: "No".text.color(Colors.white).make(),
            ),
          ],
        )
      ],
    )
        .box
        .color(Color.fromRGBO(239, 239, 239, 1))
        .roundedSM
        .padding(EdgeInsets.all(10))
        .make(),
  );
}

class ContactDetailCard extends StatelessWidget {
  final String senderName;
  final String senderPhone;
  final String receiverName;
  final String receiverPhone;

  ContactDetailCard({
    Key? key,
    required this.senderName,
    required this.senderPhone,
    required this.receiverName,
    required this.receiverPhone,
  }) : super(key: key);

  // void _launchCaller(String phoneNumber) async {
  //   final Uri url = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   // await canLaunchUrl(url);
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Uri dialNumber = Uri(scheme: 'tel', path: '9558624406');

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      // elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ContactTile(
              title: 'Sender',
              subtitle: senderName,
              phoneNumber: senderPhone,
              icon: Icons.person,
              color: Colors.green,
              onCallPressed: () {},
              // onCallPressed: () => _launchCaller(senderPhone),
            ),
            const Divider(thickness: 1, height: 15),
            ContactTile(
              title: 'Receiver',
              subtitle: receiverName,
              phoneNumber: receiverPhone,
              icon: Icons.person,
              color: Colors.red,
              onCallPressed: () {
                // callNumber();
                // canLaunchUrl(Uri(scheme: 'tel', path: '123'));
                // canLaunchUrl(dialNumber);
                // _launchCaller('9558624406');
              },
              // onCallPressed: () => _launchCaller(receiverPhone),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String phoneNumber;
  final IconData icon;
  final Color color;
  final VoidCallback onCallPressed;

  const ContactTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.phoneNumber,
    required this.icon,
    required this.color,
    required this.onCallPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.white,
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
        const SizedBox(width: 21),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                phoneNumber,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
        // IconButton(
        //   icon: Icon(Icons.call, color: Colors.green),
        //   onPressed: onCallPressed,
        // ),
      ],
    );
  }
}

