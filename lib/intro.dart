import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vtc/login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  /* 
Calling acces token from shared preferences

  Future<String?> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<void> AccessToken() async {
    String? accessToken = await getAccessToken();
    if (accessToken != null) {
      print(accessToken);
    } else {
      print('error');
    }
  }

  @override
  void initState() {
    AccessToken();
    super.initState();
  }

  */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Center(
              child: Container(
                height: 500,
                margin: const EdgeInsets.only(left: 100),
                child: Image.asset("assets/truck.png"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              }),
              child: Container(
                  width: 300,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Continuer',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ))),
            ),
          ],
        )),
      ),
    );
  }
}
