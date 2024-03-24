import 'package:flutter/material.dart';

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

    Widget buildTop(){
      return SizedBox(
        width: screenWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.location_on_sharp, size: 80, color: Colors.white,)
          ],
        ),
      );
    }

    return  Container(
        color: const Color(0xFF0000FF).withOpacity(0.9),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(child: buildTop())
            ],
          ),
        ),
      );
      // Column(
      //
      //   children: const [
      //     Center(
      //       child: Padding(
      //         padding: EdgeInsets.only(top: 40.0),
      //         child: Text(
      //           "Easy Go",
      //           style: TextStyle(fontSize: 50, color: Color(0xFF0000FF),),
      //         ),
      //       ),
      //     )
      //   ],
      // ),



  }


}
