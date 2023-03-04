// import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:tryst_pass_check/screens/barcode_evaluation_screen.dart';
// import 'package:tryst_pass_check/utils.dart' as utils;
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:tryst_pass_check/extensions.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.jwt});
  final String jwt;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MobileScannerController cameraController = MobileScannerController();
  var showCamera = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tryst Pass Check'),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: context.height * 0.15),
        child: MobileScanner(
          controller: cameraController,
          onDetect: (capture) async {
            final List<Barcode> barcodes = capture.barcodes;
            var code;
            for (final barcode in barcodes) {
              code = '${barcode.rawValue}';
              debugPrint('Barcode found! ${barcode.rawValue}');
            }
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (
                  context,
                ) =>
                    BarcodeEvaluationScreen(
                  jwt: widget.jwt,
                  code: code,
                ),
              ),
            );
            print(widget.jwt);
            print(code);
          },
        ),
      ),
    );
  }
}
