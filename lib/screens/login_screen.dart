import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tryst_pass_check/local_storage.dart';
import 'package:http/http.dart' as http;
import 'package:tryst_pass_check/screens/open_scanner_screen.dart';
import 'package:tryst_pass_check/utils.dart' as utils;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<String> attemptLogIn(String email, String password) async {
    var response = await http.post(
      Uri.parse("${utils.api}/admin/login/"),
      body: json.encode(
        {'email': email, 'password': password},
      ),
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json'
      },
    );
    return response.body;
  }

  final _localStorage = LocalStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tryst Pass Check'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  TextField(
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Enter your email here'),
                    controller: emailController,
                  ),
                  TextField(
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                        hintText: 'Enter your password here'),
                    controller: passwordController,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final email = emailController.text;
                    final password = passwordController.text;
                    final response = await attemptLogIn(email, password);
                    final result = json.decode(response);
                    // final response = await http.post(
                    //     Uri.parse("${utils.api}/admin/login/"),
                    //     body: json.encode(
                    //       {
                    //         'email': 'admin@tryst-iitd.org',
                    //         'password': 'caic_2023'
                    //       },
                    //     ),
                    //     headers: {
                    //       'Content-type': 'application/json',
                    //       'Accept': 'application/json'
                    //     });
                    // final result = json.decode(response.body);
                    if (result['error'] == null) {
                      final jwt = result['tokens']['access'];
                      debugPrint(jwt);
                      _localStorage.saveJWT(jwt);
                      if (!mounted) {}
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OpenScannerScreen(
                            jwt: jwt,
                          ),
                        ),
                      );
                    } else {
                      AlertDialog(
                        title: const Text('Invalid-Credentials'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
