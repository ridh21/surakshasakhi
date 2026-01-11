import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Privacy Reassurance Widget
/// Displays privacy information to reassure users about data safety
class PrivacyReassuranceWidget extends StatelessWidget {
  const PrivacyReassuranceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'shield',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 3.w),
              Text(
                'Your Privacy is Protected',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildPrivacyItem(theme, 'no_photography', 'No camera access'),
          SizedBox(height: 1.h),
          _buildPrivacyItem(theme, 'mic_off', 'No microphone access'),
          SizedBox(height: 1.h),
          _buildPrivacyItem(theme, 'message', 'No message reading'),
          SizedBox(height: 1.h),
          _buildPrivacyItem(theme, 'lock', 'All data encrypted'),
        ],
      ),
    );
  }

  Widget _buildPrivacyItem(ThemeData theme, String iconName, String text) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: theme.colorScheme.primary,
          size: 20,
        ),
        SizedBox(width: 3.w),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ),
      ],
    );
  }
}
