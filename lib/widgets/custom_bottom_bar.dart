import 'package:flutter/material.dart';

/// Custom bottom navigation bar for women's safety app
/// Implements thumb-reachable design with safety-first navigation hierarchy
///
/// Navigation items match the Mobile Navigation Hierarchy:
/// - Dashboard (Shield icon) - Real-time safety monitoring
/// - History (Clock icon) - Safety history and patterns
/// - Contacts (People icon) - Trusted contacts management
/// - Settings (Gear icon) - App configuration
///
/// Emergency Alert is handled as an overlay, not a bottom bar item
class CustomBottomBar extends StatelessWidget {
  /// Current selected index (0-3)
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
          unselectedItemColor:
              theme.bottomNavigationBarTheme.unselectedItemColor,
          selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
              theme.bottomNavigationBarTheme.unselectedLabelStyle,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: [
            // Dashboard - Primary safety monitoring
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_outlined, size: 24),
              activeIcon: Icon(Icons.shield, size: 24),
              label: 'Dashboard',
              tooltip: 'Safety Dashboard',
            ),

            // History - Safety patterns and incidents
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined, size: 24),
              activeIcon: Icon(Icons.history, size: 24),
              label: 'History',
              tooltip: 'Safety History',
            ),

            // Contacts - Trusted contacts management
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline, size: 24),
              activeIcon: Icon(Icons.people, size: 24),
              label: 'Contacts',
              tooltip: 'Trusted Contacts',
            ),

            // Settings - App configuration
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 24),
              activeIcon: Icon(Icons.settings, size: 24),
              label: 'Settings',
              tooltip: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
