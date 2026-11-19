
import 'package:flutter/material.dart';

import 'ui/kas/home_screen.dart';
import 'ui/kas/kas_view_model.dart';

void main() {
  runApp(const NusaKasApp());
}

class NusaKasApp extends StatefulWidget {
  const NusaKasApp({super.key});

  @override
  State<NusaKasApp> createState() => _NusaKasAppState();
}

class _NusaKasAppState extends State<NusaKasApp> {
  late final KasViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = KasViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NusaKas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
        useMaterial3: true,
      ),
      home: HomeScreen(viewModel: viewModel),
    );
  }
}
