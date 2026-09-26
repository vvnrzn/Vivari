import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'screens/care_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/parameters_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/vivari_bottom_navigation.dart';

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
      home: const VivariShell(),
    );
  }
}

class VivariShell extends StatefulWidget {
  const VivariShell({super.key});

  @override
  State<VivariShell> createState() => _VivariShellState();
}

class _VivariShellState extends State<VivariShell> {
  final _navigatorKeys = List<GlobalKey<NavigatorState>>.generate(
    3,
    (_) => GlobalKey<NavigatorState>(),
  );
  int _selectedIndex = 1;

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  Widget _buildTabNavigator(int index) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (settings) => MaterialPageRoute<void>(
        settings: settings,
        builder: (_) => switch (index) {
          0 => const ParametersScreen(),
          1 => HomeDashboard(onSelectTab: _selectTab),
          _ => const CareScreen(),
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: List<Widget>.generate(3, _buildTabNavigator),
      ),
      bottomNavigationBar: VivariBottomNavigation(
        currentIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
      ),
    );
  }
}
