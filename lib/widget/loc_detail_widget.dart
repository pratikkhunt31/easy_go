import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  const DetailWidget({
    super.key,
    required this.controller,
    required this.icon,
    required this.labelText,
  });

  final String labelText;
  final IconData icon;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.black),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Colors.black),
        ),
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF0000FF),
        ),
      ),
    );
  }
}

class LocationButton extends StatelessWidget {
  const LocationButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPress,
  });

  final String label;
  final IconData icon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          onPress;
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade500)),
          padding: const EdgeInsets.only(left: 5, top: 12, bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: const Color(0xFF0000FF),
                size: 20,
              ),
              const SizedBox(width: 3),
              Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
