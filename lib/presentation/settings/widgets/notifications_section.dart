import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Notifications Section Widget
/// Manages alert preferences for each risk level and quiet hours
class NotificationsSection extends StatelessWidget {
  final Map<String, bool> alertPreferences;
  final TimeOfDay quietHoursStart;
  final TimeOfDay quietHoursEnd;
  final int contactNotificationFrequency;
  final Function(String, bool) onAlertPreferenceChanged;
  final Function(TimeOfDay, TimeOfDay) onQuietHoursChanged;
  final Function(int) onFrequencyChanged;

  const NotificationsSection({
    super.key,
    required this.alertPreferences,
    required this.quietHoursStart,
    required this.quietHoursEnd,
    required this.contactNotificationFrequency,
    required this.onAlertPreferenceChanged,
    required this.onQuietHoursChanged,
    required this.onFrequencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notifications',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildAlertPreference(
            context,
            'Low Risk Alerts',
            'low',
            alertPreferences['low'] ?? true,
          ),
          Divider(height: 3.h),
          _buildAlertPreference(
            context,
            'Moderate Risk Alerts',
            'moderate',
            alertPreferences['moderate'] ?? true,
          ),
          Divider(height: 3.h),
          _buildAlertPreference(
            context,
            'High Risk Alerts',
            'high',
            alertPreferences['high'] ?? true,
          ),
          Divider(height: 3.h),
          _buildAlertPreference(
            context,
            'Critical Risk Alerts',
            'critical',
            alertPreferences['critical'] ?? true,
          ),
          SizedBox(height: 3.h),
          _buildQuietHours(context),
          SizedBox(height: 3.h),
          _buildNotificationFrequency(context),
        ],
      ),
    );
  }

  Widget _buildAlertPreference(
    BuildContext context,
    String label,
    String key,
    bool value,
  ) {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                _getAlertDescription(key),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: (newValue) {
            onAlertPreferenceChanged(key, newValue);
          },
        ),
      ],
    );
  }

  Widget _buildQuietHours(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () => _showQuietHoursDialog(context),
      child: Container(
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quiet Hours',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    '${quietHoursStart.format(context)} - ${quietHoursEnd.format(context)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'chevron_right',
              color: theme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationFrequency(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Notification Frequency',
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'How often to notify trusted contacts during high-risk situations',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: [
            _buildFrequencyChip(context, 'Every 5 min', 5),
            _buildFrequencyChip(context, 'Every 10 min', 10),
            _buildFrequencyChip(context, 'Every 15 min', 15),
            _buildFrequencyChip(context, 'Every 30 min', 30),
          ],
        ),
      ],
    );
  }

  Widget _buildFrequencyChip(BuildContext context, String label, int minutes) {
    final theme = Theme.of(context);
    final isSelected = contactNotificationFrequency == minutes;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          onFrequencyChanged(minutes);
        }
      },
      backgroundColor: theme.colorScheme.surface,
      selectedColor: theme.colorScheme.primaryContainer,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: isSelected
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
    );
  }

  String _getAlertDescription(String key) {
    if (key == 'low') {
      return 'Informational notifications about safe conditions';
    } else if (key == 'moderate') {
      return 'Soft warnings with safety suggestions';
    } else if (key == 'high') {
      return 'Location sharing notifications';
    } else {
      return 'Emergency alerts to contacts and security';
    }
  }

  void _showQuietHoursDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Quiet Hours'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Start Time'),
              subtitle: Text(quietHoursStart.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: quietHoursStart,
                );
                if (time != null) {
                  onQuietHoursChanged(time, quietHoursEnd);
                  Navigator.pop(context);
                }
              },
            ),
            ListTile(
              title: const Text('End Time'),
              subtitle: Text(quietHoursEnd.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: quietHoursEnd,
                );
                if (time != null) {
                  onQuietHoursChanged(quietHoursStart, time);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
