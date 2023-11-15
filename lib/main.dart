import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vtc/intro.dart';
import 'package:vtc/login.dart';
import 'package:vtc/providers/authProvider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthModel>(
          create: (context) => AuthModel(),
        ),
      ],
      child: MaterialApp(
        routes: {
          '/login': (context) => const Login(),
        },
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: const Home(),
      ),
    );
  }
}
