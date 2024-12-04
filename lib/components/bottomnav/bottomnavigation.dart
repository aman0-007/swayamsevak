import 'package:flutter/material.dart';
import 'package:swayamsevak/pages/dashboard.dart';
import 'package:swayamsevak/pages/options_page.dart';

class BottomNavApp extends StatefulWidget {
  const BottomNavApp({Key? key}) : super(key: key);

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  int _selectedIndex = 0;

  // Define the pages for navigation
  final List<Widget> _pages = [
    const UserDashboard(),
    const OptionsPage(),
    const SettingsView(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getAppBarTitle(_selectedIndex),
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'Options',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.colorScheme.onBackground.withOpacity(0.6),
        backgroundColor: theme.colorScheme.background,
        elevation: theme.bottomNavigationBarTheme.elevation ?? 8,
        selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
        unselectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onBackground.withOpacity(0.6),
        ),
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Options';
      case 2:
        return 'Settings';
      default:
        return '';
    }
  }
}

// Placeholder for SettingsView
class SettingsView extends StatelessWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Settings Page',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
