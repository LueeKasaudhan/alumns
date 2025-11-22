// lib/screens/splash_screen.dart

import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import 'no_internet_screen.dart';
import 'webview_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() async {
    await Future.delayed(Duration(seconds: 2));

    bool online = await ConnectivityService.hasInternet();
    if (online) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => WebviewScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => NoInternetScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Alumns", style: TextStyle(fontSize: 28))),
    );
  }
}
