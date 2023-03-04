import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tryst_pass_check/screens/home_screen.dart';
import 'package:tryst_pass_check/utils.dart' as utils;
import 'package:http/http.dart' as http;

class BarcodeEvaluationScreen extends StatefulWidget {
  const BarcodeEvaluationScreen(
      {super.key, required this.jwt, required this.code});

  final String jwt;
  final String code;
  @override
  State<BarcodeEvaluationScreen> createState() =>
      _BarcodeEvaluationScreenState();
}

class _BarcodeEvaluationScreenState extends State<BarcodeEvaluationScreen> {
  Future<void> evaluate(String code, String jwt) async {
    var headers = {'Authorization': 'Bearer ${widget.jwt}'};
    var request = http.MultipartRequest(
        'POST', Uri.parse('${utils.api}/admin/passes/enter/'));
    // ignore: unnecessary_string_interpolations
    request.fields.addAll({'code': '${widget.code}'});
    request.headers.addAll(headers);
    final response = await request.send();
    final result = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      debugPrint(result);
    } else {
      debugPrint(result);
    }
    try {
      final res = json.decode(result);
      setState(() {
        if (res['error'] == null) {
          evaluations = res['message'];
        } else {
          String time = res['time'];
          String error = res['error'];
          evaluations = '$error \n $time';
        }
      });
    } catch (e) {
      setState(() {
        evaluations = 'Invalid';
      });
    }
  }

  String evaluations = "";
  @override
  void initState() {
    evaluate(widget.code, widget.jwt);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tryst Pass Check'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              evaluations,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(jwt: widget.jwt),
                  ),
                );
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
