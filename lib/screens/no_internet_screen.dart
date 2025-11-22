// lib/screens/no_internet_screen.dart

import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import 'webview_screen.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("No Internet Connection", style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool online = await ConnectivityService.hasInternet();
                if (online) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => WebviewScreen()),
                  );
                }
              },
              child: Text("Retry"),
            ),
          ],
        ),
      ),
    );
  }
}
