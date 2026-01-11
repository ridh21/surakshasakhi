import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';

/// Contact status card widget showing message delivery and read status
class ContactStatusCardWidget extends StatelessWidget {
  final Map<String, dynamic> contact;

  const ContactStatusCardWidget({super.key, required this.contact});

  String _getStatusText() {
    if (contact["messageRead"] == true) {
      return 'Message read';
    } else if (contact["messageDelivered"] == true) {
      return 'Message delivered';
    } else {
      return 'Sending...';
    }
  }

  Color _getStatusColor(BuildContext context) {
    final theme = Theme.of(context);
    if (contact["messageRead"] == true) {
      return theme.colorScheme.secondary;
    } else if (contact["messageDelivered"] == true) {
      return theme.colorScheme.primary;
    } else {
      return theme.colorScheme.onSurfaceVariant;
    }
  }

  IconData _getStatusIcon() {
    if (contact["messageRead"] == true) {
      return Icons.done_all;
    } else if (contact["messageDelivered"] == true) {
      return Icons.done;
    } else {
      return Icons.schedule;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else {
      return '${difference.inHours}h ago';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Contact avatar
          ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: CustomImageWidget(
              imageUrl: contact["avatar"] as String,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              semanticLabel: contact["semanticLabel"] as String,
            ),
          ),

          SizedBox(width: 3.w),

          // Contact info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact["name"] as String,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  contact["relation"] as String,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Icon(
                      _getStatusIcon(),
                      size: 14,
                      color: _getStatusColor(context),
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _getStatusText(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: _getStatusColor(context),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '• ${_getTimeAgo(contact["lastUpdated"] as DateTime)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Call button
          InkWell(
            onTap: () {
              // In production, this would trigger phone dialer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${contact["name"]}...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: 'phone',
                color: theme.colorScheme.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
