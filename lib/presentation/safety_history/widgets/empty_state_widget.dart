import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Empty state widget for periods with good safety scores
class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? submessage;

  const EmptyStateWidget({super.key, required this.message, this.submessage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.light
                    ? AppTheme.secondaryLight.withValues(alpha: 0.1)
                    : AppTheme.secondaryDark.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                size: 64,
                color: theme.brightness == Brightness.light
                    ? AppTheme.secondaryLight
                    : AppTheme.secondaryDark,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              message,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            if (submessage != null) ...[
              SizedBox(height: 1.h),
              Text(
                submessage!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
