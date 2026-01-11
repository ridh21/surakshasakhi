import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/permission_card_widget.dart';
import './widgets/privacy_reassurance_widget.dart';

/// Permission Setup Screen
/// Guides users through essential location and sensor permissions required for safety monitoring
class PermissionSetup extends StatefulWidget {
  const PermissionSetup({super.key});

  @override
  State<PermissionSetup> createState() => _PermissionSetupState();
}

class _PermissionSetupState extends State<PermissionSetup> {
  bool _isLocationPermissionGranted = false;
  bool _isMotionPermissionGranted = false;
  bool _isProcessing = false;
  bool _showWhyPermissions = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (kIsWeb) {
      setState(() {
        _isLocationPermissionGranted = true;
        _isMotionPermissionGranted = true;
      });
      return;
    }

    final locationStatus = await Permission.locationAlways.status;

    // Use activityRecognition on Android, sensors on iOS
    PermissionStatus motionStatus;
    if (!kIsWeb && Platform.isAndroid) {
      motionStatus = await Permission.activityRecognition.status;
    } else {
      motionStatus = await Permission.sensors.status;
    }

    setState(() {
      _isLocationPermissionGranted = locationStatus.isGranted;
      _isMotionPermissionGranted = motionStatus.isGranted;
    });
  }

  Future<void> _requestLocationPermission() async {
    if (kIsWeb) {
      setState(() => _isLocationPermissionGranted = true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // First request location when in use
      final whenInUseStatus = await Permission.locationWhenInUse.request();

      if (whenInUseStatus.isGranted) {
        // Then request always permission
        final alwaysStatus = await Permission.locationAlways.request();

        setState(() {
          _isLocationPermissionGranted = alwaysStatus.isGranted;
          _isProcessing = false;
        });

        if (!alwaysStatus.isGranted) {
          _showPermissionDeniedDialog(
            'Location',
            'Always allow location access is required for continuous safety monitoring.',
          );
        }
      } else {
        setState(() => _isProcessing = false);
        _showPermissionDeniedDialog(
          'Location',
          'Location access is required for safety monitoring.',
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorDialog(
        'Failed to request location permission. Please try again.',
      );
    }
  }

  Future<void> _requestMotionPermission() async {
    if (kIsWeb) {
      setState(() => _isMotionPermissionGranted = true);
      return;
    }

    setState(() => _isProcessing = true);

    try {
      // Use activityRecognition on Android, sensors on iOS
      PermissionStatus status;
      if (!kIsWeb && Platform.isAndroid) {
        status = await Permission.activityRecognition.request();
      } else {
        status = await Permission.sensors.request();
      }

      setState(() {
        _isMotionPermissionGranted = status.isGranted;
        _isProcessing = false;
      });

      if (!status.isGranted) {
        _showPermissionDeniedDialog(
          'Motion Sensors',
          'Motion sensor access is required for movement pattern detection.',
        );
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      _showErrorDialog(
        'Failed to request motion sensor permission. Please try again.',
      );
    }
  }

  void _showPermissionDeniedDialog(String permissionName, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$permissionName Permission Required'),
        content: Text(
          '$message\n\nPlease enable this permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleContinue() {
    if (_isLocationPermissionGranted && _isMotionPermissionGranted) {
      Navigator.of(
        context,
        rootNavigator: true,
      ).pushNamed('/trusted-contacts-setup');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Safety Permissions',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'To keep you safe, SafeGuardian needs access to your location and motion sensors for continuous monitoring.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    PermissionCardWidget(
                      title: 'Location Access',
                      description:
                          'Continuous monitoring of your location to detect unsafe areas and provide real-time safety scores.',
                      iconName: 'location_on',
                      isGranted: _isLocationPermissionGranted,
                      onRequestPermission: _requestLocationPermission,
                      isProcessing: _isProcessing,
                    ),
                    SizedBox(height: 2.h),
                    PermissionCardWidget(
                      title: 'Motion Sensors',
                      description:
                          'Detects your movement patterns, walking speed, and stops to identify potential safety concerns.',
                      iconName: 'directions_walk',
                      isGranted: _isMotionPermissionGranted,
                      onRequestPermission: _requestMotionPermission,
                      isProcessing: _isProcessing,
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info_outline',
                            color: theme.colorScheme.secondary,
                            size: 24,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Background app refresh is required for continuous monitoring even when the app is not active.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 3.h),
                    PrivacyReassuranceWidget(),
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () {
                        setState(
                          () => _showWhyPermissions = !_showWhyPermissions,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outline),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Why These Permissions?',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            CustomIconWidget(
                              iconName: _showWhyPermissions
                                  ? 'expand_less'
                                  : 'expand_more',
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_showWhyPermissions) ...[
                      SizedBox(height: 2.h),
                      Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWhyPermissionItem(
                              theme,
                              'Location Always',
                              'Enables real-time safety score calculation based on your current area, time, and movement patterns.',
                            ),
                            SizedBox(height: 2.h),
                            _buildWhyPermissionItem(
                              theme,
                              'Motion Sensors',
                              'Detects if you stop moving unexpectedly or deviate from your normal walking patterns.',
                            ),
                            SizedBox(height: 2.h),
                            _buildWhyPermissionItem(
                              theme,
                              'Background Refresh',
                              'Allows continuous monitoring even when you\'re not actively using the app.',
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow,
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      (_isLocationPermissionGranted &&
                          _isMotionPermissionGranted)
                      ? _handleContinue
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isProcessing
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          'Continue',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhyPermissionItem(
    ThemeData theme,
    String title,
    String description,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
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
    );
  }
}
