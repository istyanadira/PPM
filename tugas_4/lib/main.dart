import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'screens/not_found_screen.dart';

void main() {
  runApp(const NusaTravelApp());
}

class NusaTravelApp extends StatelessWidget {
  const NusaTravelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaTravel',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF087E8B),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F8FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF087E8B),
          foregroundColor: Colors.white,
        ),
      ),

      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,

      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => NotFoundScreen(
            routeName: settings.name ?? 'unknown',
          ),
        );
      },
    );
  }
}