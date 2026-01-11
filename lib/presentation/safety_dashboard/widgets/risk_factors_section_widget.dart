import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RiskFactorsSectionWidget extends StatefulWidget {
  final int safetyScore;

  const RiskFactorsSectionWidget({super.key, required this.safetyScore});

  @override
  State<RiskFactorsSectionWidget> createState() =>
      _RiskFactorsSectionWidgetState();
}

class _RiskFactorsSectionWidgetState extends State<RiskFactorsSectionWidget> {
  int? _expandedIndex;

  List<Map<String, dynamic>> _getRiskFactors() {
    final currentHour = DateTime.now().hour;
    final isLateNight = currentHour >= 22 || currentHour < 6;

    return [
      {
        'title': 'Time-Based Risk',
        'icon': 'schedule',
        'value': isLateNight ? 'High' : 'Low',
        'color': isLateNight
            ? const Color(0xFFE89560)
            : const Color(0xFF9BC179),
        'description': isLateNight
            ? 'Late night hours (10 PM - 6 AM) increase risk factors. Consider using well-lit routes and informing trusted contacts.'
            : 'Current time is within safe hours. Continue monitoring your surroundings.',
      },
      {
        'title': 'Location Category',
        'icon': 'place',
        'value': 'Campus Path',
        'color': const Color(0xFF9BC179),
        'description':
            'You are currently on a campus path. These areas are generally well-monitored with security presence.',
      },
      {
        'title': 'Movement Patterns',
        'icon': 'directions_walk',
        'value': 'Normal',
        'color': const Color(0xFF9BC179),
        'description':
            'Your walking speed and movement patterns are consistent with your usual routine. No anomalies detected.',
      },
      {
        'title': 'Routine Deviation',
        'icon': 'route',
        'value': widget.safetyScore > 50 ? 'Detected' : 'None',
        'color': widget.safetyScore > 50
            ? const Color(0xFFF0B865)
            : const Color(0xFF9BC179),
        'description': widget.safetyScore > 50
            ? 'Your current route differs from your usual patterns. The AI is monitoring this deviation for safety.'
            : 'You are following your regular route patterns. No unusual deviations detected.',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskFactors = _getRiskFactors();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            child: Text(
              'Risk Factors',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 2.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: riskFactors.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final factor = riskFactors[index];
              final isExpanded = _expandedIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedIndex = isExpanded ? null : index;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isExpanded
                          ? theme.colorScheme.primary.withValues(alpha: 0.3)
                          : theme.colorScheme.outline.withValues(alpha: 0.2),
                      width: isExpanded ? 2 : 1,
                    ),
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
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: (factor['color'] as Color).withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: CustomIconWidget(
                              iconName: factor['icon'] as String,
                              color: factor['color'] as Color,
                              size: 20,
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  factor['title'] as String,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 2.w,
                                    vertical: 0.5.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: (factor['color'] as Color)
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    factor['value'] as String,
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: factor['color'] as Color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CustomIconWidget(
                            iconName: isExpanded
                                ? 'expand_less'
                                : 'expand_more',
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 24,
                          ),
                        ],
                      ),

                      if (isExpanded) ...[
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            factor['description'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
