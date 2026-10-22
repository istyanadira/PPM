import 'package:flutter/material.dart';

import '../models/tour_package.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/not_found_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String detail = '/detail';

  static const List<TourPackage> packages = [
    TourPackage(
      id: 'TR001',
      title: 'Eksplorasi Bali',
      description:
          'Nikmati pantai indah, pura bersejarah, sawah terasering, '
          'dan budaya Bali yang memikat.',
      price: 1250000,
      imageUrl:
          'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=1000',
    ),
    TourPackage(
      id: 'TR002',
      title: 'Petualangan Yogyakarta',
      description:
          'Jelajahi Candi Borobudur, Malioboro, kuliner lokal, '
          'dan kekayaan budaya Jawa.',
      price: 850000,
      imageUrl:
          'https://images.unsplash.com/photo-1584810359583-96fc3448beaa?w=1000',
    ),
    TourPackage(
      id: 'TR003',
      title: 'Labuan Bajo',
      description:
          'Nikmati panorama pulau, laut biru, dan petualangan '
          'menjelajahi keindahan alam Nusa Tenggara Timur.',
      price: 2750000,
      imageUrl:
          'https://images.unsplash.com/photo-1516690561799-46d8f74f9abf?w=1000',
    ),
    TourPackage(
      id: 'TR004',
      title: 'Danau Toba',
      description:
          'Rasakan udara sejuk, pemandangan danau vulkanik, '
          'dan budaya Batak yang khas.',
      price: 1650000,
      imageUrl:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=1000',
    ),
  ];

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        home: (context) => const HomeScreen(),
      };

  static Route<dynamic>? onGenerateRoute(
    RouteSettings settings,
  ) {
    if (settings.name == detail) {
      final argument = settings.arguments;

      if (argument is TourPackage) {
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => DetailScreen(
            package: argument,
          ),
        );
      }

      return MaterialPageRoute(
        builder: (context) => const NotFoundScreen(
          routeName: 'Detail dengan argumen tidak valid',
        ),
      );
    }

    return null;
  }
}