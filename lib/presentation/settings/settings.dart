import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_section.dart';
import './widgets/notifications_section.dart';
import './widgets/privacy_section.dart';
import './widgets/safety_preferences_section.dart';
import './widgets/support_section.dart';

/// Settings Screen
/// Provides comprehensive configuration for safety monitoring preferences
/// Tab bar navigation structure with Settings tab active
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Safety Preferences State
  final Map<String, double> _riskThresholds = {
    'low': 80.0,
    'moderate': 60.0,
    'high': 40.0,
    'critical': 20.0,
  };
  bool _routineLearningEnabled = true;
  double _monitoringSensitivity = 2.0;

  // Notifications State
  final Map<String, bool> _alertPreferences = {
    'low': true,
    'moderate': true,
    'high': true,
    'critical': true,
  };
  TimeOfDay _quietHoursStart = const TimeOfDay(hour: 22, minute: 0);
  TimeOfDay _quietHoursEnd = const TimeOfDay(hour: 7, minute: 0);
  int _contactNotificationFrequency = 10;

  // Account State
  final String _userName = 'Ridham Patel';
  final String _userEmail = 'ridhampatel2k4@gmail.com';
  final int _trustedContactsCount = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Settings', style: theme.appBarTheme.titleTextStyle),
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: theme.appBarTheme.elevation,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _handleSearch,
            tooltip: 'Search settings',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              SafetyPreferencesSection(
                onThresholdChanged: _handleThresholdChanged,
                onRoutineLearningChanged: _handleRoutineLearningChanged,
                onSensitivityChanged: _handleSensitivityChanged,
                thresholds: _riskThresholds,
                routineLearningEnabled: _routineLearningEnabled,
                monitoringSensitivity: _monitoringSensitivity,
              ),
              NotificationsSection(
                alertPreferences: _alertPreferences,
                quietHoursStart: _quietHoursStart,
                quietHoursEnd: _quietHoursEnd,
                contactNotificationFrequency: _contactNotificationFrequency,
                onAlertPreferenceChanged: _handleAlertPreferenceChanged,
                onQuietHoursChanged: _handleQuietHoursChanged,
                onFrequencyChanged: _handleFrequencyChanged,
              ),
              PrivacySection(
                onViewCollectedData: _handleViewCollectedData,
                onDeleteAllData: _handleDeleteAllData,
              ),
              AccountSection(
                onManageTrustedContacts: _handleManageTrustedContacts,
                onEditProfile: _handleEditProfile,
                onSignOut: _handleSignOut,
                userName: _userName,
                userEmail: _userEmail,
                trustedContactsCount: _trustedContactsCount,
              ),
              SupportSection(
                onHowSafetyScoreWorks: _handleHowSafetyScoreWorks,
                onContactSupport: _handleContactSupport,
                onPrivacyPolicy: _handlePrivacyPolicy,
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  // Safety Preferences Handlers
  void _handleThresholdChanged(String key, double value) {
    setState(() {
      _riskThresholds[key] = value;
    });
    _showFeedbackSnackBar(
      '${key.toUpperCase()} risk threshold updated to ${value.toInt()}',
    );
  }

  void _handleRoutineLearningChanged(bool value) {
    setState(() {
      _routineLearningEnabled = value;
    });
    _showFeedbackSnackBar(
      value ? 'Routine learning enabled' : 'Routine learning disabled',
    );
  }

  void _handleSensitivityChanged(double value) {
    setState(() {
      _monitoringSensitivity = value;
    });
    String label = value <= 1.5 ? 'Low' : (value <= 2.5 ? 'Medium' : 'High');
    _showFeedbackSnackBar('Monitoring sensitivity set to $label');
  }

  // Notifications Handlers
  void _handleAlertPreferenceChanged(String key, bool value) {
    if (key == 'critical' && !value) {
      _showConfirmationDialog(
        'Disable Critical Alerts?',
        'Critical alerts are essential for your safety. Are you sure you want to disable them?',
        () {
          setState(() {
            _alertPreferences[key] = value;
          });
          _showFeedbackSnackBar('${key.toUpperCase()} alerts disabled');
        },
      );
    } else {
      setState(() {
        _alertPreferences[key] = value;
      });
      _showFeedbackSnackBar(
        value
            ? '${key.toUpperCase()} alerts enabled'
            : '${key.toUpperCase()} alerts disabled',
      );
    }
  }

  void _handleQuietHoursChanged(TimeOfDay start, TimeOfDay end) {
    setState(() {
      _quietHoursStart = start;
      _quietHoursEnd = end;
    });
    _showFeedbackSnackBar('Quiet hours updated');
  }

  void _handleFrequencyChanged(int minutes) {
    setState(() {
      _contactNotificationFrequency = minutes;
    });
    _showFeedbackSnackBar(
      'Notification frequency set to every $minutes minutes',
    );
  }

  // Privacy Handlers
  void _handleViewCollectedData() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildCollectedDataSheet(),
    );
  }

  void _handleDeleteAllData() {
    _showConfirmationDialog(
      'Delete All Data?',
      'This will permanently remove all stored routine patterns and safety history. This action cannot be undone.',
      () {
        _showFeedbackSnackBar('All data deleted successfully');
      },
    );
  }

  // Account Handlers
  void _handleManageTrustedContacts() {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/trusted-contacts-setup');
  }

  void _handleEditProfile() {
    _showFeedbackSnackBar('Profile editing coming soon');
  }

  void _handleSignOut() {
    _showConfirmationDialog(
      'Sign Out?',
      'Are you sure you want to sign out of your account?',
      () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamedAndRemoveUntil('/permission-setup', (route) => false);
      },
    );
  }

  // Support Handlers
  void _handleHowSafetyScoreWorks() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _buildSafetyScoreExplanationSheet(),
    );
  }

  void _handleContactSupport() {
    _showFeedbackSnackBar('Support contact coming soon');
  }

  void _handlePrivacyPolicy() {
    _showFeedbackSnackBar('Privacy policy coming soon');
  }

  void _handleSearch() {
    _showFeedbackSnackBar('Search functionality coming soon');
  }

  // Helper Methods
  void _showFeedbackSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showConfirmationDialog(
    String title,
    String content,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectedDataSheet() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      height: 70.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Collected Data',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView(
              children: [
                _buildDataItem(
                  'Location Patterns',
                  'Anonymized routine paths and frequently visited areas',
                  Icons.location_on_outlined,
                ),
                _buildDataItem(
                  'Time Patterns',
                  'Typical travel times and schedule patterns',
                  Icons.access_time,
                ),
                _buildDataItem(
                  'Movement Data',
                  'Walking speed and stop detection patterns',
                  Icons.directions_walk,
                ),
                _buildDataItem(
                  'Safety History',
                  'Past safety scores and risk assessments',
                  Icons.history,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String title, String description, IconData icon) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyScoreExplanationSheet() {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      height: 80.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'How Safety Score Works',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          Expanded(
            child: ListView(
              children: [
                _buildExplanationSection(
                  'Real-Time AI Assessment',
                  'Our AI continuously monitors your location, time, and movement patterns to calculate a safety score from 0-100.',
                  Icons.psychology,
                ),
                _buildExplanationSection(
                  'Risk Factors',
                  'The score considers late-night hours, isolated areas, movement patterns, and deviations from your normal routine.',
                  Icons.warning_amber,
                ),
                _buildExplanationSection(
                  'Graduated Response',
                  'Based on your score, the app provides soft warnings, safety suggestions, location sharing, or emergency alerts.',
                  Icons.notifications_active,
                ),
                _buildExplanationSection(
                  'Privacy-First Design',
                  'All processing happens on your device. We never access your camera, microphone, or messages.',
                  Icons.shield,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationSection(
    String title,
    String description,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 24),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
