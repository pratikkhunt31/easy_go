import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Terms and Conditions"),
        backgroundColor: const Color(0xFF0000FF),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Introduction",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "Welcome to Easy Go. By using the App, you agree to these Terms and Conditions. If you do not agree, do not use the App. We reserve the right to modify these Terms at any time.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "User Responsibilities",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "As a user, you agree to:\n- Provide accurate information during registration and keep your account information updated.\n- Maintain the confidentiality of your account credentials.\n- Use the App for lawful purposes only.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Services Provided",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "The App connects users with delivery partners for parcel delivery services. We act as an intermediary and are not responsible for the actual delivery.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "User Conduct",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "You agree not to:\n- Use the App for illegal purposes.\n- Harass, threaten, or misuse the App.\n- Post false or misleading information.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Booking and Payment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Bookings must be made through the App.\n- Payments are processed through secure third-party payment gateways.\n- Prices are subject to change based on various factors such as distance, weight, and time.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Cancellations and Refunds",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Cancellations can be made through the App within a specified time frame.\n- Refunds will be processed according to our cancellation policy.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Delivery Partner Responsibilities",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Delivery partners are independent contractors and not employees of [Your App Name].\n- They are responsible for handling parcels with care and delivering them within the agreed time frame.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Limitation of Liability",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- We are not liable for any direct, indirect, incidental, or consequential damages arising from the use of the App.\n- Our liability is limited to the amount paid by you for the delivery service.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "Your use of the App is also governed by our Privacy Policy, which can be found [here/link to Privacy Policy].",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Intellectual Property",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- The App and its content, including logos, graphics, and text, are our property and protected by copyright laws.\n- You may not reproduce, distribute, or create derivative works without our permission.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Termination",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "We reserve the right to terminate your access to the App if you violate these Terms.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Governing Law",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "These Terms are governed by the laws of [Your Jurisdiction]. Any disputes will be resolved in the courts of [Your Jurisdiction].",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Contact Us",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "If you have any questions or concerns about these Terms, please contact us at easygo9444@gmal.com",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
