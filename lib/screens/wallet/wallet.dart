import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Wallet"),
        elevation: 0,
        backgroundColor: const Color(0xFF0000FF),
      ),
      body: const Center(
        child: Text("Wallet"),
      ),
    );
  }
}
