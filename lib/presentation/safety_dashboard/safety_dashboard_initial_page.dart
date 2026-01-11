import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/current_location_card_widget.dart';
import './widgets/risk_factors_section_widget.dart';
import './widgets/safety_score_gauge_widget.dart';
import './widgets/safety_suggestions_card_widget.dart';

class SafetyDashboardInitialPage extends StatefulWidget {
  const SafetyDashboardInitialPage({super.key});

  @override
  State<SafetyDashboardInitialPage> createState() =>
      _SafetyDashboardInitialPageState();
}

class _SafetyDashboardInitialPageState
    extends State<SafetyDashboardInitialPage> {
  bool _isRefreshing = false;
  int _currentSafetyScore = 25; // Mock safety score (0-100)
  final String _currentLocation = '123 Campus Drive, University District';
  final double _gpsAccuracy = 12.5; // meters
  final bool _isMonitoringActive = true;

  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);

    // Simulate data refresh
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
      // Update with new mock data
      _currentSafetyScore = (_currentSafetyScore + 5) % 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              'Safety Dashboard',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            actions: [
              // Monitoring status indicator
              Container(
                margin: EdgeInsets.only(right: 4.w),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _isMonitoringActive
                      ? theme.colorScheme.secondary.withValues(alpha: 0.12)
                      : theme.colorScheme.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _isMonitoringActive
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      _isMonitoringActive ? 'Active' : 'Inactive',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _isMonitoringActive
                            ? theme.colorScheme.secondary
                            : theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: 2.h),

                // Safety Score Gauge
                SafetyScoreGaugeWidget(
                  score: _currentSafetyScore,
                  isRefreshing: _isRefreshing,
                ),

                SizedBox(height: 3.h),

                // Current Location Card
                CurrentLocationCardWidget(
                  location: _currentLocation,
                  gpsAccuracy: _gpsAccuracy,
                  onShareLocation: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Location shared with trusted contacts'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: theme.colorScheme.secondary,
                      ),
                    );
                  },
                ),

                SizedBox(height: 3.h),

                // Risk Factors Section
                RiskFactorsSectionWidget(safetyScore: _currentSafetyScore),

                SizedBox(height: 3.h),

                // Safety Suggestions Card
                SafetySuggestionsCardWidget(safetyScore: _currentSafetyScore),

                SizedBox(height: 10.h), // Space for emergency button
              ],
            ),
          ),
        ],
      ),
    );
  }
}
