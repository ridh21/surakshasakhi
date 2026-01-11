import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/contact_status_card_widget.dart';
import './widgets/emergency_header_widget.dart';
import './widgets/location_display_widget.dart';

/// Emergency Alert Screen
/// Activates automatically when safety score reaches critical levels
/// or through manual emergency button activation
class EmergencyAlert extends StatefulWidget {
  const EmergencyAlert({super.key});

  @override
  State<EmergencyAlert> createState() => _EmergencyAlertState();
}

class _EmergencyAlertState extends State<EmergencyAlert>
    with WidgetsBindingObserver {
  // Timer management
  int _countdownSeconds = 30;
  int _totalElapsedSeconds = 0;
  bool _isAlertActive = true;
  bool _isLocationSharing = true;

  // Location data
  Position? _currentPosition;
  bool _isLoadingLocation = true;
  String _locationError = '';

  // Contact status tracking
  final List<Map<String, dynamic>> _trustedContacts = [
    {
      "id": 1,
      "name": "Vijay Patel",
      "phone": "+91 99099 90999",
      "relation": "Emergency Contact",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1453e1878-1763300003100.png",
      "semanticLabel":
          "Profile photo of a woman with shoulder-length brown hair wearing a light blue blouse",
      "messageDelivered": true,
      "messageRead": false,
      "lastUpdated": DateTime.now().subtract(Duration(seconds: 15)),
    },
    {
      "id": 2,
      "name": "Campus Security",
      "phone": "+91 89876 54321",
      "relation": "Security Team",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_10972c890-1763298967952.png",
      "semanticLabel":
          "Profile photo of a security officer in uniform with short gray hair",
      "messageDelivered": true,
      "messageRead": true,
      "lastUpdated": DateTime.now().subtract(Duration(seconds: 8)),
    },
    {
      "id": 3,
      "name": "Mom",
      "phone": "+1 (555) 234-5678",
      "relation": "Family",
      "avatar":
          "https://img.rocket.new/generatedImages/rocket_gen_img_187661766-1763300418934.png",
      "semanticLabel":
          "Profile photo of a middle-aged woman with short blonde hair wearing glasses",
      "messageDelivered": false,
      "messageRead": false,
      "lastUpdated": DateTime.now().subtract(Duration(seconds: 25)),
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeEmergencyMode();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disableEmergencyMode();
    super.dispose();
  }

  /// Initialize emergency mode with screen wake lock and location tracking
  Future<void> _initializeEmergencyMode() async {
    // Set maximum brightness
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    // Keep screen awake
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Start countdown timer
    _startCountdownTimer();

    // Get current location
    await _getCurrentLocation();

    // Trigger haptic feedback
    HapticFeedback.heavyImpact();
  }

  /// Disable emergency mode settings
  void _disableEmergencyMode() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
  }

  /// Start countdown timer for alert escalation
  void _startCountdownTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (!mounted || !_isAlertActive) return;

      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
          _totalElapsedSeconds++;
        } else if (_totalElapsedSeconds < 60) {
          // After 30 seconds, continue counting to 60
          _totalElapsedSeconds++;
        }
      });

      // Trigger haptic feedback every 10 seconds
      if (_countdownSeconds % 10 == 0) {
        HapticFeedback.mediumImpact();
      }

      _startCountdownTimer();
    });
  }

  /// Get current GPS location with high accuracy
  Future<void> _getCurrentLocation() async {
    try {
      // Check location permission
      final permission = await Permission.location.status;
      if (!permission.isGranted) {
        final result = await Permission.location.request();
        if (!result.isGranted) {
          setState(() {
            _locationError = 'Location permission denied';
            _isLoadingLocation = false;
          });
          return;
        }
      }

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationError = 'Location services are disabled';
          _isLoadingLocation = false;
        });
        return;
      }

      // Get current position with high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
        _locationError = '';
      });

      // Continue tracking location in background
      _trackLocationContinuously();
    } catch (e) {
      setState(() {
        _locationError = 'Unable to get location';
        _isLoadingLocation = false;
      });
    }
  }

  /// Track location continuously with updates
  void _trackLocationContinuously() {
    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen((Position position) {
      if (mounted && _isAlertActive && _isLocationSharing) {
        setState(() {
          _currentPosition = position;
        });
      }
    });
  }

  /// Cancel emergency alert
  void _cancelAlert() {
    HapticFeedback.mediumImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Text(
            'Cancel Emergency Alert?',
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            'Are you sure you want to cancel this emergency alert? Your trusted contacts will be notified that you are safe.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No, Keep Active'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAlertActive = false;
                });
                Navigator.of(context).pop();
                Navigator.of(context, rootNavigator: true).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
              ),
              child: Text('Yes, I\'m Safe'),
            ),
          ],
        );
      },
    );
  }

  /// Call emergency services (911)
  void _callEmergencyServices() {
    HapticFeedback.heavyImpact();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            children: [
              CustomIconWidget(
                iconName: 'phone',
                color: theme.colorScheme.error,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text('Call 911?', style: theme.textTheme.titleLarge),
            ],
          ),
          content: Text(
            'This will immediately dial emergency services (911). Only use this feature if you are in immediate danger.',
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // In production, this would trigger actual phone dialer
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Calling 911...'),
                    backgroundColor: theme.colorScheme.error,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
              ),
              child: Text('Call Now'),
            ),
          ],
        );
      },
    );
  }

  /// Send custom message to contacts
  void _sendCustomMessage() {
    final theme = Theme.of(context);
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Send Custom Message', style: theme.textTheme.titleLarge),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add specific details about your situation:',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              TextField(
                controller: messageController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'e.g., "Near the library parking lot, suspicious person following me"',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Custom message sent to all contacts'),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                );
              },
              child: Text('Send Message'),
            ),
          ],
        );
      },
    );
  }

  /// Extend alert timer
  void _extendTimer() {
    HapticFeedback.lightImpact();

    setState(() {
      _countdownSeconds += 30;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Timer extended by 30 seconds'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// Toggle location sharing
  void _toggleLocationSharing(bool value) {
    setState(() {
      _isLocationSharing = value;
    });

    HapticFeedback.selectionClick();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value
              ? 'Live location sharing enabled'
              : 'Live location sharing paused',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        _cancelAlert();
        return false;
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.error.withValues(alpha: 0.05),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Emergency header with countdown
                  EmergencyHeaderWidget(
                    countdownSeconds: _countdownSeconds,
                    totalElapsedSeconds: _totalElapsedSeconds,
                  ),

                  SizedBox(height: 3.h),

                  // Location display
                  LocationDisplayWidget(
                    currentPosition: _currentPosition,
                    isLoadingLocation: _isLoadingLocation,
                    locationError: _locationError,
                    isLocationSharing: _isLocationSharing,
                    onToggleLocationSharing: _toggleLocationSharing,
                  ),

                  SizedBox(height: 3.h),

                  // Trusted contacts status
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'people',
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Contact Status',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _trustedContacts.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 1.5.h),
                          itemBuilder: (context, index) {
                            final contact = _trustedContacts[index];
                            return ContactStatusCardWidget(contact: contact);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Action buttons
                  ActionButtonsWidget(
                    onCancelAlert: _cancelAlert,
                    onCallEmergency: _callEmergencyServices,
                    onSendCustomMessage: _sendCustomMessage,
                    onExtendTimer: _extendTimer,
                  ),

                  SizedBox(height: 2.h),

                  // Safety information
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'info',
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            'Your location is being shared with trusted contacts. Stay in a well-lit area if possible.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
