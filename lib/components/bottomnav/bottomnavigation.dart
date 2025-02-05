import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swayamsevak/pages/dashboard.dart';
import 'package:swayamsevak/pages/popages/pooptions.dart';

import '../../pages/auth/authoption.dart';

class POBottomNavApp extends StatefulWidget {
  const POBottomNavApp({Key? key}) : super(key: key);

  @override
  State<POBottomNavApp> createState() => _POBottomNavAppState();
}

class _POBottomNavAppState extends State<POBottomNavApp> {
  int _selectedIndex = 0;

  // Define the pages for navigation
  final List<Widget> _pages = [
    const UserDashboard(),
     POOptionsPage(),
    const ProfileView(),
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
            icon: Icon(Icons.person),
            label: 'Profile',
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


class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    // Clear all saved SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Profile Page',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _logout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
