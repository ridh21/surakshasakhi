import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Safety Preferences Section Widget
/// Displays risk threshold sliders, routine learning toggle, and monitoring sensitivity
class SafetyPreferencesSection extends StatefulWidget {
  final Function(String, double) onThresholdChanged;
  final Function(bool) onRoutineLearningChanged;
  final Function(double) onSensitivityChanged;
  final Map<String, double> thresholds;
  final bool routineLearningEnabled;
  final double monitoringSensitivity;

  const SafetyPreferencesSection({
    super.key,
    required this.onThresholdChanged,
    required this.onRoutineLearningChanged,
    required this.onSensitivityChanged,
    required this.thresholds,
    required this.routineLearningEnabled,
    required this.monitoringSensitivity,
  });

  @override
  State<SafetyPreferencesSection> createState() =>
      _SafetyPreferencesSectionState();
}

class _SafetyPreferencesSectionState extends State<SafetyPreferencesSection> {
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
            'Safety Preferences',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          _buildThresholdSlider(
            context,
            'Low Risk Threshold',
            'low',
            widget.thresholds['low'] ?? 80.0,
            Colors.green,
          ),
          SizedBox(height: 2.h),
          _buildThresholdSlider(
            context,
            'Moderate Risk Threshold',
            'moderate',
            widget.thresholds['moderate'] ?? 60.0,
            Colors.orange,
          ),
          SizedBox(height: 2.h),
          _buildThresholdSlider(
            context,
            'High Risk Threshold',
            'high',
            widget.thresholds['high'] ?? 40.0,
            Colors.deepOrange,
          ),
          SizedBox(height: 2.h),
          _buildThresholdSlider(
            context,
            'Critical Risk Threshold',
            'critical',
            widget.thresholds['critical'] ?? 20.0,
            Colors.red,
          ),
          SizedBox(height: 3.h),
          _buildRoutineLearningToggle(context),
          SizedBox(height: 3.h),
          _buildSensitivitySlider(context),
        ],
      ),
    );
  }

  Widget _buildThresholdSlider(
    BuildContext context,
    String label,
    String key,
    double value,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${value.toInt()}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: color,
            thumbColor: color,
            overlayColor: color.withValues(alpha: 0.2),
            inactiveTrackColor: theme.colorScheme.outline,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 100,
            onChanged: (newValue) {
              widget.onThresholdChanged(key, newValue);
            },
          ),
        ),
        Text(
          _getThresholdDescription(key, value),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRoutineLearningToggle(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
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
                  'Routine Learning',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Learn your daily patterns to improve safety detection',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: widget.routineLearningEnabled,
            onChanged: (value) {
              widget.onRoutineLearningChanged(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSensitivitySlider(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Monitoring Sensitivity',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              _getSensitivityLabel(widget.monitoringSensitivity),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Slider(
          value: widget.monitoringSensitivity,
          min: 1,
          max: 3,
          divisions: 2,
          onChanged: (value) {
            widget.onSensitivityChanged(value);
          },
        ),
        Text(
          'Adjust how sensitive the app is to potential risks',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getThresholdDescription(String key, double value) {
    if (key == 'low') {
      return 'Safety score above ${value.toInt()} is considered safe';
    } else if (key == 'moderate') {
      return 'Safety score ${value.toInt()}-${(widget.thresholds['low'] ?? 80).toInt()} triggers soft warnings';
    } else if (key == 'high') {
      return 'Safety score ${value.toInt()}-${(widget.thresholds['moderate'] ?? 60).toInt()} shares live location';
    } else {
      return 'Safety score below ${value.toInt()} triggers emergency alerts';
    }
  }

  String _getSensitivityLabel(double value) {
    if (value <= 1.5) {
      return 'Low';
    } else if (value <= 2.5) {
      return 'Medium';
    } else {
      return 'High';
    }
  }
}
