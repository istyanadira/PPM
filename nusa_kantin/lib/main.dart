
import 'package:flutter/material.dart';

import 'ui/core/window_size.dart';
import 'ui/menu/menu_screen.dart';
import 'ui/menu/menu_view_model.dart';
import 'ui/pesanan/pesanan_screen.dart';

void main() {
  runApp(const NusaKantinApp());
}

class NusaKantinApp extends StatelessWidget {
  const NusaKantinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaKantin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        scaffoldBackgroundColor: const Color(0xFFF8FAF8),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final MenuViewModel _viewModel = MenuViewModel();

  int _selectedIndex = 0;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ukuran = WindowSizeHelper.getWindowSize(context);

    final bool compact = ukuran == WindowSize.compact;
    final bool expanded = ukuran == WindowSize.expanded;

    final List<Widget> halaman = [
      MenuScreen(viewModel: _viewModel),
      PesananScreen(viewModel: _viewModel),
    ];

    if (compact) {
      return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: halaman,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.restaurant_menu_outlined),
              selectedIcon: Icon(Icons.restaurant_menu),
              label: 'Menu',
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_outlined),
              selectedIcon: Icon(Icons.shopping_bag),
              label: 'Pesanan',
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              extended: expanded,
              labelType: expanded
                  ? null
                  : NavigationRailLabelType.all,
              minWidth: 72,
              minExtendedWidth: 180,
              backgroundColor: Colors.white,
              selectedIconTheme: const IconThemeData(
                color: Colors.green,
              ),
              selectedLabelTextStyle: TextStyle(
                color: Colors.green.shade800,
                fontWeight: FontWeight.bold,
              ),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.restaurant_menu_outlined),
                  selectedIcon: Icon(Icons.restaurant_menu),
                  label: Text('Menu'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_bag_outlined),
                  selectedIcon: Icon(Icons.shopping_bag),
                  label: Text('Pesanan'),
                ),
              ],
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: halaman,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
