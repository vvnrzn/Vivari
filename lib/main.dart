import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'screens/home_dashboard.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vivari',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: VivariTheme.app,
      home: const HomeDashboard(),
    );
  }
}
