import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmergencyButtonWidget extends StatefulWidget {
  const EmergencyButtonWidget({super.key});

  @override
  State<EmergencyButtonWidget> createState() => _EmergencyButtonWidgetState();
}

class _EmergencyButtonWidgetState extends State<EmergencyButtonWidget> {
  bool _showOptions = false;

  void _handleLongPress() {
    setState(() => _showOptions = true);
  }

  void _handleEmergencyAction(String action) {
    setState(() => _showOptions = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$action activated'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Emergency Options Overlay
        if (_showOptions)
          Positioned(
            bottom: 12.h,
            left: 4.w,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow,
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Emergency Options',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  _buildEmergencyOption(
                    context,
                    icon: 'notifications',
                    title: 'Soft Alert',
                    subtitle: 'Notify trusted contacts',
                    color: const Color(0xFFF0B865),
                    onTap: () => _handleEmergencyAction('Soft Alert'),
                  ),

                  SizedBox(height: 1.5.h),

                  _buildEmergencyOption(
                    context,
                    icon: 'share_location',
                    title: 'Share Location',
                    subtitle: 'Immediate location sharing',
                    color: const Color(0xFFE89560),
                    onTap: () => _handleEmergencyAction('Location Sharing'),
                  ),

                  SizedBox(height: 1.5.h),

                  _buildEmergencyOption(
                    context,
                    icon: 'emergency',
                    title: 'Full Emergency',
                    subtitle: 'Alert all contacts & security',
                    color: theme.colorScheme.error,
                    onTap: () => _handleEmergencyAction('Full Emergency Alert'),
                  ),

                  SizedBox(height: 2.h),

                  TextButton(
                    onPressed: () => setState(() => _showOptions = false),
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ),
          ),

        // Main Emergency Button
        Positioned(
          bottom: 2.h,
          child: GestureDetector(
            onLongPress: _handleLongPress,
            child: Container(
              width: 70.w,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.error,
                    theme.colorScheme.error.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.error.withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'emergency',
                    color: Colors.white,
                    size: 24,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'EMERGENCY',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Long Press Hint
        if (!_showOptions)
          Positioned(
            bottom: 0.5.h,
            child: Text(
              'Long press for options',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildEmergencyOption(
    BuildContext context, {
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(iconName: icon, color: color, size: 20),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(iconName: 'arrow_forward', color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
