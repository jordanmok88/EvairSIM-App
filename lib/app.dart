import 'package:flutter/material.dart';

import 'core/constants/app_constants.dart';
import 'presentation/pages/shell/webview_shell_page.dart';

/// Native shell for EvairSIM. Post 2026-04 WebView migration: the APP
/// no longer rebuilds the H5 UI in Dart — it hosts the H5 site inside a
/// single full-screen [WebViewShellPage]. Keep this widget deliberately
/// thin; everything visible to the user is shipped from H5.
class EvairSimApp extends StatelessWidget {
  const EvairSimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6600)),
        useMaterial3: true,
      ),
      home: const WebViewShellPage(),
    );
  }
}
