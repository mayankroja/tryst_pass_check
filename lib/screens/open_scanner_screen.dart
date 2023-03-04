import 'package:flutter/material.dart';
import 'package:tryst_pass_check/screens/home_screen.dart';

class OpenScannerScreen extends StatefulWidget {
  const OpenScannerScreen({super.key, required this.jwt});
  final String jwt;

  @override
  State<OpenScannerScreen> createState() => _OpenScannerScreenState();
}

class _OpenScannerScreenState extends State<OpenScannerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tryst Pass Check'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Open Scanner'),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(jwt: widget.jwt),
            ),
          ),
        ),
      ),
    );
  }
}
