

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter/services.dart';

class WebviewScreen extends StatefulWidget {
  @override
  _WebviewScreenState createState() => _WebviewScreenState();
}

void setSystemUIMode() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class _WebviewScreenState extends State<WebviewScreen>
    with WidgetsBindingObserver {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    setSystemUIMode();
    WidgetsBinding.instance.addObserver(this);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url;

            if (url.contains("accounts.google.com")) {
              _openChromeTab(url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },

          onPageStarted: (url) {
            setState(() => isLoading = true);
          },
          onPageFinished: (url) {
            setState(() => isLoading = false);
          },
          onWebResourceError: (error) {
            print("Webview error: ${error.description}");
          },
        ),
      )
      ..loadRequest(Uri.parse("https://alumns.com"));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // user returned from browser to reload the WebView
      controller.reload();
    }
  }

  Future<void> _openChromeTab(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: const CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes(
            lightParams: CustomTabsColorSchemeParams(
              toolbarColor: Colors.white,
            ),
          ),
          urlBarHidingEnabled: true,
          instantAppsEnabled: true,
          showTitle: true,
        ),
      );
    } catch (e) {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: const CustomTabsOptions(),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
