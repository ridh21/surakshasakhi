import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SafetySuggestionsCardWidget extends StatelessWidget {
  final int safetyScore;

  const SafetySuggestionsCardWidget({super.key, required this.safetyScore});

  List<Map<String, dynamic>> _getSuggestions(int score) {
    if (score <= 30) {
      return [
        {
          'icon': 'check_circle',
          'text':
              'You\'re in a safe area. Continue your journey with confidence.',
          'color': const Color(0xFF9BC179),
        },
        {
          'icon': 'visibility',
          'text': 'Stay aware of your surroundings as you travel.',
          'color': const Color(0xFF9BC179),
        },
      ];
    } else if (score <= 60) {
      return [
        {
          'icon': 'warning',
          'text': 'Consider using well-lit and populated routes.',
          'color': const Color(0xFFF0B865),
        },
        {
          'icon': 'phone',
          'text': 'Keep your phone accessible and charged.',
          'color': const Color(0xFFF0B865),
        },
        {
          'icon': 'group',
          'text': 'Travel with a companion if possible.',
          'color': const Color(0xFFF0B865),
        },
      ];
    } else if (score <= 80) {
      return [
        {
          'icon': 'share_location',
          'text': 'Share your live location with trusted contacts.',
          'color': const Color(0xFFE89560),
        },
        {
          'icon': 'call',
          'text': 'Consider calling a trusted contact during your journey.',
          'color': const Color(0xFFE89560),
        },
        {
          'icon': 'directions',
          'text': 'Use alternative, safer routes if available.',
          'color': const Color(0xFFE89560),
        },
      ];
    } else {
      return [
        {
          'icon': 'emergency',
          'text': 'High risk detected. Consider emergency alert activation.',
          'color': const Color(0xFFD87770),
        },
        {
          'icon': 'local_taxi',
          'text': 'Use a trusted transportation service immediately.',
          'color': const Color(0xFFD87770),
        },
        {
          'icon': 'security',
          'text': 'Contact campus security or local authorities if needed.',
          'color': const Color(0xFFD87770),
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _getSuggestions(safetyScore);

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
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'lightbulb',
                  color: theme.colorScheme.tertiary,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                'Safety Suggestions',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: suggestions.length,
            separatorBuilder: (context, index) => SizedBox(height: 1.5.h),
            itemBuilder: (context, index) {
              final suggestion = suggestions[index];

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(1.5.w),
                    decoration: BoxDecoration(
                      color: (suggestion['color'] as Color).withValues(
                        alpha: 0.12,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomIconWidget(
                      iconName: suggestion['icon'] as String,
                      color: suggestion['color'] as Color,
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      suggestion['text'] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
