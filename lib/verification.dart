// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtc/feed.dart';
import 'package:vtc/login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:vtc/providers/authProvider.dart';

class Verification extends StatefulWidget {
  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  int digitCount = 0;
  List<String> digitValues = ['', '', '', ''];
  Future<void> showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(
                color: Colors.green,
              ),
              SizedBox(height: 16.0),
              Text('Loading...'),
            ],
          ),
        );
      },
    );
  }

  Future<void> VerifyOtp(String phoneNumber, String otp) async {
    final Uri url =
        Uri.parse('https://vtc-lourd.onrender.com/api/customers/verify-otp');

    Map<String, dynamic> postData = {'phone_number': phoneNumber, 'otp': otp};
    String jsonBody = jsonEncode(postData);
    print(jsonBody);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      print('Response data: ${response.body}');

      final jsonResponse = json.decode(response.body);
      final accessToken = jsonResponse['access_token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('access_token', accessToken);
      showLoadingDialog(context);

      // ignore: use_build_context_synchronously
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pop(); // Close the loading dialog
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Feed(),
          ),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Code OTP incorrecte. Veuillez réessayer.'),
        ),
      );
      print('Error: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset("assets/back.png")),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Saisir le code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Un code a été envoyé à +${authModel.phoneNumber}',
                style: const TextStyle(
                    color: Color.fromARGB(255, 113, 113, 113), fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 60,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.length == 1 && index <= 3) {
                            digitValues[index] = value;
                            digitCount++;
                            FocusScope.of(context).nextFocus();
                          }
                        },
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    if (digitCount == 4) {
                      String concatenatedValue = digitValues.join();
                      print(concatenatedValue);
                      await VerifyOtp(authModel.phoneNumber, concatenatedValue);
                    }
                  },
                  child: Container(
                    width: 300,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: const Center(
                      child: Text(
                        'Continuer',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: GestureDetector(
                  onTap: (() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  }),
                  child: const Text(
                    'Changer le numéro de téléphone',
                    style: TextStyle(
                        color: Color.fromARGB(255, 104, 44, 40), fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}
