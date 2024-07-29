import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy Policy"),
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
                "Privacy Policy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.black26),
              const Text(
                "Welcome to EasyGo!",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "We value your privacy and are committed to protecting your personal information. "
                "This Privacy Policy outlines how we collect, use, store, and protect your data.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Information We Collect:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Personal Information: Name, contact details, address, and payment information."
                "\n- Usage Data: Information about how you use our app, including pages visited and actions taken."
                "\n- Device Information: Information about the device you use to access our app, including IP address .",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Purpose of Data Collection:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- To provide and improve our services."
                "\n- To process transactions and send related information."
                "\n- To communicate with you, including sending updates and promotional offers."
                "\n- To analyze usage patterns to enhance user experience.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Data Sharing Practices:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "We do not sell or share your personal information with third parties except as necessary to provide our services, "
                "comply with legal obligations, or with your consent.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "User Rights:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- You have the right to access, correct, or delete your personal information."
                "\n- You can opt-out of receiving promotional communications at any time.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Data Security:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- We implement appropriate security measures to protect your personal information from unauthorized access, alteration, disclosure, or destruction."
                "\n- For any questions or concerns about our privacy practices, please contact us at easygo9444@gmal.com.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              const Text(
                "Cancellation/Refund Policy",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.black26),
              const Text(
                "Cancellation Policy:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- Please note that once an order is placed, it cannot be canceled.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Refund Policy:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              const Text(
                "- If you are eligible for a refund, it will be processed within 5 to 7 business days."
                "\n- Refunds will be issued to the original payment method used at the time of purchase."
                "\n- For any issues regarding your order or refund status, please contact our support team at easygo9444@gmal.com",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              const Text(
                "Contact Us",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.black26),
              const Text(
                "- We are here to assist you with any questions or concerns you may have. Please reach out to us using the following contact information:.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Email: easygo9444@gmail.com"
                "\nOperational Address: easygo9444@gmail.com",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              Text(
                "Our support team is available 9:00 AM to 5:00 PM  to assist you.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              const Text(
                "Shipping & Delivery",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Divider(color: Colors.black26),
              const Text(
                "- We strive to deliver your parcels promptly and efficiently. Below are our shipping and delivery policies:.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 10),
              const Text(
                "Shipping Time Frame:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 3),
              Text(
                "- Orders are processed and shipped within give period of time."
                "\n -For more information on your shipment status or any delivery-related queries, please contact us at easygo9444@gmail.com.",
                style: TextStyle(fontSize: 14),
              ),
              // const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}