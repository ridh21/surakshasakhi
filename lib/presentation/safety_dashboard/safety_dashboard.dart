import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../widgets/custom_bottom_bar.dart';
import './safety_dashboard_initial_page.dart';

class SafetyDashboard extends StatefulWidget {
  const SafetyDashboard({super.key});

  @override
  SafetyDashboardState createState() => SafetyDashboardState();
}

class SafetyDashboardState extends State<SafetyDashboard> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int currentIndex = 0;

  // ALL CustomBottomBar routes in EXACT order matching CustomBottomBar items
  final List<String> routes = [
    '/safety-dashboard', // index 0 - Dashboard (Shield icon)
    '/safety-history', // index 1 - History (Clock icon)
    '/trusted-contacts-setup', // index 2 - Contacts (People icon)
    '/settings', // index 3 - Settings (Gear icon)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: navigatorKey,
        initialRoute: '/safety-dashboard',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/safety-dashboard' || '/':
              return MaterialPageRoute(
                builder: (context) => const SafetyDashboardInitialPage(),
                settings: settings,
              );
            default:
              // Check AppRoutes.routes for all other routes
              if (AppRoutes.routes.containsKey(settings.name)) {
                return MaterialPageRoute(
                  builder: AppRoutes.routes[settings.name]!,
                  settings: settings,
                );
              }
              return null;
          }
        },
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: (index) {
          // For the routes that are not in the AppRoutes.routes, do not navigate to them.
          if (!AppRoutes.routes.containsKey(routes[index])) {
            return;
          }
          if (currentIndex != index) {
            setState(() => currentIndex = index);
            navigatorKey.currentState?.pushReplacementNamed(routes[index]);
          }
        },
      ),
    );
  }
}
