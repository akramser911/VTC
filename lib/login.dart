import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtc/intro.dart';
import 'package:vtc/providers/authProvider.dart';
import 'package:vtc/verification.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _phoneNumber = TextEditingController();
  String token = "";
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = _phoneNumber.text;
      print('Phone Number: +213$phoneNumber');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Verification()),
      );
    } else {
      print('no number found');
    }
  }

  Future<void> Auth(String phoneNumber) async {
    final Uri url =
        Uri.parse('https://vtc-lourd.onrender.com/api/customers/send-otp');

    Map<String, dynamic> postData = {
      'phone_number': phoneNumber,
    };

    String jsonBody = jsonEncode(postData);

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
    } else {
      print('Error: ${response.statusCode}');
      print('Response data: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authModel = Provider.of<AuthModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()),
                          );
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
                        'Home',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    height: 200,
                    margin: const EdgeInsets.only(left: 100),
                    child: Image.asset("assets/truck.png"),
                  ),
                  const SizedBox(
                    width: 250,
                    child: Text(
                      'Saisissez votre numéro de téléphone',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      const Text(
                        '+213',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextFormField(
                          controller: _phoneNumber,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numéro de téléphone';
                            }
                            if (RegExp(r'^[0-9]{9}$').hasMatch(value)) {
                              return null;
                            } else {
                              return 'Le numéro de téléphone est incorrect';
                            }
                          },
                          maxLength: 9,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Numéro de téléphone',
                            hintText: '000-000-000',
                            counterText: '',
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    'Nous enverrons un code afin de vérifier votre numéro',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: (() {
                      _submitForm();
                      Auth('213' + _phoneNumber.text);
                      authModel.setPhoneNumber('213' + _phoneNumber.text);
                    }),
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
                  const SizedBox(
                    height: 50,
                  ),
                  /*Container(
                    width: 400,
                    height: 1,
                    color: const Color.fromARGB(255, 194, 193, 193),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 201, 200, 200),
                              width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25))),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.whatsapp,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Se connecter avec Whatsapp',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ))),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 201, 200, 200),
                              width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25))),
                      child: Center(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.facebook,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Se connecter avec Facebook',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      )))*/
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}
