import 'package:flutter/material.dart';

import '../../widget/custom_widget.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color(0xFF0000FF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_sharp),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "Account",
            //   style: TextStyle(
            //     fontSize: 30,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 0),
            EditItem(
              title: "Photo",
              widget: Column(
                children: [
                  const Icon(
                    Icons.person,
                    size: 100,
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.lightBlueAccent,
                    ),
                    child: const Text("Upload Image"),
                  ),
                ],
              ),
            ),
            const EditItem(
              title: "Name",
              widget: TextField(),
            ),
            const SizedBox(height: 20),
            const EditItem(
              title: "Email",
              widget: TextField(),
            ),
          ],
        ),
      ),
    );
  }
}
