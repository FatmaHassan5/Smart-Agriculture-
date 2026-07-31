import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../state/prediction_provider.dart';
import 'predict_screen.dart';
import 'crop_details_screen.dart';
import 'insights_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  final _pages = const [
    PredictScreen(),
    CropDetailsScreen(),
    InsightsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // A single shared PredictionProvider lets the Predict screen write the
    // last result and the Insights screen read it, without extra plumbing.
    return ChangeNotifierProvider(
      create: (_) => PredictionProvider(),
      child: Scaffold(
        body: IndexedStack(index: _index, children: _pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          backgroundColor: Colors.white,
          indicatorColor: AppColors.lightGreen.withOpacity(0.25),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.insights_outlined),
              selectedIcon: Icon(Icons.insights),
              label: "Predict",
            ),
            NavigationDestination(
              icon: Icon(Icons.eco_outlined),
              selectedIcon: Icon(Icons.eco),
              label: "Crops",
            ),
            NavigationDestination(
              icon: Icon(Icons.lightbulb_outline),
              selectedIcon: Icon(Icons.lightbulb),
              label: "Insights",
            ),
          ],
        ),
      ),
    );
  }
}
