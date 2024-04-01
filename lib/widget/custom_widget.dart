import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomButton extends StatelessWidget {
  final String? hint;
  final Function onPress;
  final Color? color;
  final BorderRadius borderRadius;

  const CustomButton(
      {super.key, required this.hint, required this.onPress, this.color, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: EasyButton(
          type: EasyButtonType.elevated,
          idleStateWidget: Text(
            hint!,
            style: const TextStyle(fontSize: 18),
          ),
          loadingStateWidget: const CircularProgressIndicator(),
          useWidthAnimation: false,
          useEqualLoadingStateWidgetDimension: true,
          width: 100,
          height: 40,
          elevation: 0.0,
          contentGap: 8.0,
          buttonColor: color!,
          onPressed: onPress,
        ),
      ),
    );
  }
}

TextFormField buildTextFormField(
    TextEditingController nameController, String fieldName, IconData icon,
    {IconData? sufIcon}) {
  return TextFormField(
    controller: nameController,
    cursorColor: Colors.black,
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
              onPressed: () {},
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
