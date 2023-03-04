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
    //   var headers = {
    //     'Authorization':
    //         'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjkzMzAzNDg4LCJpYXQiOjE2Nzc3NTE0ODgsImp0aSI6ImU3NWE2NjlhOTdmNzRiY2JiMzdiNGI1ZjEyZjRmODkzIiwidXNlcl9pZCI6N30.uT1iH8qSh1srmR3TSdPzuFx-QbbgIaomV4AcBj70tB4'
    //   };
    //   var request = http.MultipartRequest(
    //       'POST', Uri.parse('https://api.tryst-iitd.org/admin/passes/enter/'));
    //   request.fields.addAll({'code': '872e51a1-5905-41ef-bab4-84acf47dfe21'});

    //   request.headers.addAll(headers);

    //   http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   print(await response.stream.bytesToString());
    // } else {
    //   print(response.reasonPhrase);
    // }
    final response = await http.post(
        Uri.parse('${utils.api}/admin/passes/enter/'),
        body: json.encode("{'code': '$code'}"),
        headers: {
          'Authorization': 'Bearer ${widget.jwt}',
          'Content-type': 'application/json;charset=UTF-8',
          'Charset': 'utf-8'
        });
    final result = json.decode(response.body);
    try {
      var jsonobj = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
    //   print(result);
    //   if (response.statusCode == 200) {
    //     setState(() {
    //       evaluations = 'Entry was Sucessful';
    //     });
    //   } else {
    //     setState(() {
    //       evaluations = 'error';
    //     });
    //   }
  }

  String evaluations = "nothing happened";
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
          children: [
            Text(evaluations),
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
