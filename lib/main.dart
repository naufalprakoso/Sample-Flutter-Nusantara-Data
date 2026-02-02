import 'package:flutter/material.dart';
import 'package:nusantara_data/nusantara_data.dart';

import 'theme/theme.dart';
import 'screens/home_screen.dart';
import 'screens/location_picker_screen.dart';
import 'screens/search_screen.dart';
import 'screens/postal_code_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/ui_components_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize NusantaraData library
  await NusantaraData.initialize();

  runApp(const NusantaraSampleApp());
}

class NusantaraSampleApp extends StatelessWidget {
  const NusantaraSampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nusantara Data Sample',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

enum Screen {
  home,
  locationPicker,
  search,
  postalCode,
  statistics,
  uiComponents,
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Screen _currentScreen = Screen.home;

  void _navigateTo(Screen screen) {
    setState(() {
      _currentScreen = screen;
    });
  }

  void _goBack() {
    setState(() {
      _currentScreen = Screen.home;
    });
  }

  @override
  Widget build(BuildContext context) {
    return switch (_currentScreen) {
      Screen.home => HomeScreen(
          onNavigate: _navigateTo,
        ),
      Screen.locationPicker => LocationPickerScreen(
          onBack: _goBack,
        ),
      Screen.search => SearchScreen(
          onBack: _goBack,
        ),
      Screen.postalCode => PostalCodeScreen(
          onBack: _goBack,
        ),
      Screen.statistics => StatisticsScreen(
          onBack: _goBack,
        ),
      Screen.uiComponents => UIComponentsScreen(
          onBack: _goBack,
        ),
    };
  }
}
