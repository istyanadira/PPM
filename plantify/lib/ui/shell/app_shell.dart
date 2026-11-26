import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/repositories/plant_task_repository.dart';
import '../checklist/checklist_screen.dart';
import '../home/home_screen.dart';
import '../plantpedia/plantpedia_screen.dart';
import '../schedule/schedule_screen.dart';

/// Kerangka utama aplikasi: satu NavigationBar dengan empat tab.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    ScheduleScreen(),
    ChecklistScreen(),
    PlantpediaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final taskRepository = context.read<PlantTaskRepository>();

    // Muat tugas lebih awal agar badge langsung terisi.
    // (Aman dipanggil berkali-kali: repository hanya memuat sekali.)
    taskRepository.loadTasks();

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: ListenableBuilder(
        listenable: taskRepository,
        builder: (context, _) {
          final pending = taskRepository.pendingCount;

          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() => _currentIndex = index);
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home_rounded),
                label: 'Beranda',
              ),
              const NavigationDestination(
                icon: Icon(Icons.calendar_month_outlined),
                selectedIcon: Icon(Icons.calendar_month_rounded),
                label: 'Jadwal',
              ),
              NavigationDestination(
                icon: Badge(
                  isLabelVisible: pending > 0,
                  label: Text('$pending'),
                  child: const Icon(Icons.checklist_rounded),
                ),
                selectedIcon: Badge(
                  isLabelVisible: pending > 0,
                  label: Text('$pending'),
                  child: const Icon(Icons.checklist_rounded),
                ),
                label: 'Checklist',
              ),
              const NavigationDestination(
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book_rounded),
                label: 'Plantpedia',
              ),
            ],
          );
        },
      ),
    );
  }
}