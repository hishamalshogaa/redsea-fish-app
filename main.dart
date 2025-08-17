import 'package:flutter/material.dart';
import 'screens/map_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/sightings_screen.dart';
import 'screens/analysis_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RedSeaApp());
}

class RedSeaApp extends StatelessWidget {
  const RedSeaApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Red Sea Fish',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: Colors.teal, brightness: Brightness.dark, useMaterial3: true),
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _pages = const [MapScreen(), CameraScreen(), AnalysisScreen(), SightingsScreen(), SettingsScreen()];
  final _labels = const ['الخريطة','الكاميرا','تحليل','مشاهداتي','إعدادات'];
  final _icons  = const [Icons.map_outlined, Icons.camera_alt_outlined, Icons.analytics_outlined, Icons.list_alt, Icons.settings];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: List.generate(_pages.length, (i) => NavigationDestination(icon: Icon(_icons[i]), label: _labels[i])),
      ),
    );
  }
}
