import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CurrentLocationCardWidget extends StatelessWidget {
  final String location;
  final double gpsAccuracy;
  final VoidCallback onShareLocation;

  const CurrentLocationCardWidget({
    super.key,
    required this.location,
    required this.gpsAccuracy,
    required this.onShareLocation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Location',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      location,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // GPS Accuracy Indicator
          Row(
            children: [
              CustomIconWidget(
                iconName: 'gps_fixed',
                color: gpsAccuracy < 20
                    ? theme.colorScheme.secondary
                    : theme.colorScheme.tertiary,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'GPS Accuracy: ${gpsAccuracy.toStringAsFixed(1)}m',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: gpsAccuracy < 20
                      ? theme.colorScheme.secondary.withValues(alpha: 0.12)
                      : theme.colorScheme.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  gpsAccuracy < 20 ? 'Excellent' : 'Good',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: gpsAccuracy < 20
                        ? theme.colorScheme.secondary
                        : theme.colorScheme.tertiary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Share Location Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onShareLocation,
              icon: CustomIconWidget(
                iconName: 'share_location',
                color: Colors.white,
                size: 18,
              ),
              label: Text('Share Location'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
