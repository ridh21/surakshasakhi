import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Individual history item with expandable details and swipe actions
class HistoryItemWidget extends StatefulWidget {
  final Map<String, dynamic> historyData;
  final VoidCallback onViewMap;
  final VoidCallback onShare;
  final VoidCallback onAddNote;

  const HistoryItemWidget({
    super.key,
    required this.historyData,
    required this.onViewMap,
    required this.onShare,
    required this.onAddNote,
  });

  @override
  State<HistoryItemWidget> createState() => _HistoryItemWidgetState();
}

class _HistoryItemWidgetState extends State<HistoryItemWidget> {
  bool _isExpanded = false;

  Color _getRiskColor(String riskLevel, ThemeData theme) {
    switch (riskLevel.toLowerCase()) {
      case 'critical':
        return theme.brightness == Brightness.light
            ? AppTheme.criticalLight
            : AppTheme.criticalDark;
      case 'high':
        return theme.brightness == Brightness.light
            ? AppTheme.warningLight
            : AppTheme.warningDark;
      case 'moderate':
        return theme.brightness == Brightness.light
            ? AppTheme.accentLight
            : AppTheme.accentDark;
      case 'low':
        return theme.brightness == Brightness.light
            ? AppTheme.secondaryLight
            : AppTheme.secondaryDark;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskColor = _getRiskColor(widget.historyData['riskLevel'], theme);

    return Slidable(
      key: ValueKey(widget.historyData['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => widget.onViewMap(),
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            icon: Icons.map_outlined,
            label: 'Map',
          ),
          SlidableAction(
            onPressed: (context) => widget.onShare(),
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            icon: Icons.share_outlined,
            label: 'Share',
          ),
          SlidableAction(
            onPressed: (context) => widget.onAddNote(),
            backgroundColor: theme.colorScheme.tertiary,
            foregroundColor: theme.colorScheme.onTertiary,
            icon: Icons.note_add_outlined,
            label: 'Note',
          ),
        ],
      ),
      child: InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main content
              Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Safety score badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 3.w,
                            vertical: 0.8.h,
                          ),
                          decoration: BoxDecoration(
                            color: riskColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: riskColor, width: 1.5),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${widget.historyData['safetyScore']}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: riskColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 1.w),
                              Text(
                                widget.historyData['riskLevel'].toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: riskColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        // Timestamp
                        Text(
                          widget.historyData['timestamp'],
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.5.h),

                    // Location
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'location_on',
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            widget.historyData['location'],
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),

                    // Primary risk factors
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: (widget.historyData['riskFactors'] as List)
                          .map(
                            (factor) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.5.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    theme.colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                factor,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),

              // Expanded details
              if (_isExpanded) ...[
                Divider(
                  height: 1,
                  color: theme.colorScheme.outline.withValues(alpha: 0.3),
                ),
                Padding(
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Movement data
                      _buildDetailRow(
                        context,
                        'Movement',
                        widget.historyData['movementData'],
                        Icons.directions_walk,
                      ),
                      SizedBox(height: 1.h),

                      // Environmental factors
                      _buildDetailRow(
                        context,
                        'Environment',
                        widget.historyData['environmentalFactors'],
                        Icons.wb_sunny_outlined,
                      ),
                      SizedBox(height: 1.h),

                      // AI reasoning
                      _buildDetailRow(
                        context,
                        'AI Analysis',
                        widget.historyData['aiReasoning'],
                        Icons.psychology_outlined,
                      ),
                    ],
                  ),
                ),
              ],

              // Expand/collapse indicator
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 1.h),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: _isExpanded ? 'expand_less' : 'expand_more',
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIconWidget(
          iconName: icon
              .toString()
              .split('.')
              .last
              .replaceAll('IconData(U+', '')
              .replaceAll(')', ''),
          size: 18,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
