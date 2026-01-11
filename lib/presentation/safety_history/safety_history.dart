import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/date_section_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/history_filter_bar_widget.dart';
import './widgets/history_item_widget.dart';
import './widgets/safety_summary_card_widget.dart';

/// Safety History screen with comprehensive timeline of safety scores and incidents
/// Implements tab bar navigation structure with History tab active
class SafetyHistory extends StatefulWidget {
  const SafetyHistory({super.key});

  @override
  State<SafetyHistory> createState() => _SafetyHistoryState();
}

class _SafetyHistoryState extends State<SafetyHistory> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  bool _isLoading = false;
  bool _isSearching = false;

  // Mock data for safety history
  final List<Map<String, dynamic>> _historyData = [
    {
      "id": 1,
      "date": "Today",
      "timestamp": "10:45 PM",
      "location": "Campus Path near Library Block",
      "safetyScore": 45,
      "riskLevel": "high",
      "riskFactors": ["Late night", "Isolated area", "Low lighting"],
      "movementData": "Walking speed: 3.2 km/h, Stopped for 2 minutes",
      "environmentalFactors": "Poor lighting, No nearby people detected",
      "aiReasoning":
          "High risk detected due to late hour (10:45 PM) combined with isolated campus path and reduced walking speed indicating potential concern.",
    },
    {
      "id": 2,
      "date": "Today",
      "timestamp": "6:30 PM",
      "location": "Main Street near Coffee Shop",
      "safetyScore": 78,
      "riskLevel": "low",
      "riskFactors": ["Normal hours", "Public area"],
      "movementData": "Walking speed: 4.5 km/h, Continuous movement",
      "environmentalFactors": "Well-lit area, High pedestrian traffic",
      "aiReasoning":
          "Low risk scenario with normal evening hours in well-populated public area with consistent movement pattern.",
    },
    {
      "id": 3,
      "date": "Yesterday",
      "timestamp": "11:20 PM",
      "location": "Hostel Route via Park Road",
      "safetyScore": 35,
      "riskLevel": "critical",
      "riskFactors": [
        "Very late night",
        "Deviation from routine",
        "Isolated route",
      ],
      "movementData": "Walking speed: 2.8 km/h, Multiple stops detected",
      "environmentalFactors": "Minimal lighting, No nearby activity",
      "aiReasoning":
          "Critical risk identified: Late night travel (11:20 PM) on non-routine path with reduced speed and multiple stops in poorly lit area. Emergency contacts notified.",
    },
    {
      "id": 4,
      "date": "Yesterday",
      "timestamp": "3:15 PM",
      "location": "University Campus - Academic Block",
      "safetyScore": 92,
      "riskLevel": "low",
      "riskFactors": ["Daytime", "Campus area"],
      "movementData": "Walking speed: 4.0 km/h, Normal pattern",
      "environmentalFactors": "Daylight, High campus activity",
      "aiReasoning":
          "Optimal safety conditions with daytime travel in familiar campus environment during peak activity hours.",
    },
    {
      "id": 5,
      "date": "2 Days Ago",
      "timestamp": "9:45 PM",
      "location": "Shopping District - Market Street",
      "safetyScore": 62,
      "riskLevel": "moderate",
      "riskFactors": ["Evening hours", "Crowded area"],
      "movementData": "Walking speed: 3.8 km/h, Consistent movement",
      "environmentalFactors": "Moderate lighting, Busy commercial area",
      "aiReasoning":
          "Moderate risk due to evening timing, but mitigated by high pedestrian traffic and commercial area activity.",
    },
  ];

  // Mock weekly summary data
  final Map<String, dynamic> _weeklySummary = {
    "avgScore": 68,
    "totalEvents": 24,
    "highRiskCount": 3,
    "chartLabels": ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
    "chartData": [75, 82, 68, 55, 72, 45, 78],
  };

  // Recent search locations
  final List<String> _recentLocations = [
    "Campus Path near Library Block",
    "Main Street near Coffee Shop",
    "Hostel Route via Park Road",
    "University Campus - Academic Block",
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _handleFilterChange(String filter) {
    setState(() => _selectedFilter = filter);
  }

  void _handleDateRangeSelection() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              onPrimary: theme.colorScheme.onPrimary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      // Handle date range filtering
    }
  }

  void _handleSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });
  }

  void _handleViewMap(Map<String, dynamic> item) {
    // Navigate to map view with location
  }

  void _handleShare(Map<String, dynamic> item) {
    // Share safety report
  }

  void _handleAddNote(Map<String, dynamic> item) {
    // Show dialog to add personal note
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final noteController = TextEditingController();

        return AlertDialog(
          title: Text('Add Note', style: theme.textTheme.titleLarge),
          content: TextField(
            controller: noteController,
            decoration: InputDecoration(
              hintText: 'Add context or personal notes...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Save note
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _handleExportReport() {
    // Generate and export PDF report
  }

  List<Map<String, dynamic>> _getFilteredHistory() {
    if (_selectedFilter == 'all') {
      return _historyData;
    }
    return _historyData
        .where((item) => item['riskLevel'] == _selectedFilter)
        .toList();
  }

  Map<String, List<Map<String, dynamic>>> _groupByDate(
    List<Map<String, dynamic>> data,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};
    for (var item in data) {
      final date = item['date'];
      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredData = _getFilteredHistory();
    final groupedData = _groupByDate(filteredData);
    final hasData = filteredData.isNotEmpty;

    return Column(
      children: [
        // App bar content
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 1.h,
            left: 4.w,
            right: 4.w,
            bottom: 1.h,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            border: Border(
              bottom: BorderSide(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Safety History',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: _handleExportReport,
                    icon: CustomIconWidget(
                      iconName: 'file_download',
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                    tooltip: 'Export Report',
                  ),
                ],
              ),
              SizedBox(height: 1.h),

              // Search bar
              TextField(
                controller: _searchController,
                onChanged: _handleSearch,
                decoration: InputDecoration(
                  hintText: 'Search by location...',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      size: 20,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            _handleSearch('');
                          },
                          icon: CustomIconWidget(
                            iconName: 'close',
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 1.5.h,
                  ),
                ),
              ),

              // Recent locations suggestions
              if (_isSearching && _searchController.text.isEmpty) ...[
                SizedBox(height: 1.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: _recentLocations.map((location) {
                    return InkWell(
                      onTap: () {
                        _searchController.text = location;
                        _handleSearch(location);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 0.8.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'history',
                              size: 14,
                              color: theme.colorScheme.primary,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              location,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),

        // Filter bar
        HistoryFilterBarWidget(
          selectedFilter: _selectedFilter,
          onFilterSelected: _handleFilterChange,
          onDateRangePressed: _handleDateRangeSelection,
        ),

        // Content
        Expanded(
          child: hasData
              ? RefreshIndicator(
                  onRefresh: _handleRefresh,
                  color: theme.colorScheme.primary,
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 1.h, bottom: 2.h),
                    itemCount: groupedData.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return SafetySummaryCardWidget(
                          period: 'Weekly',
                          summaryData: _weeklySummary,
                        );
                      }

                      final dateIndex = index - 1;
                      final date = groupedData.keys.elementAt(dateIndex);
                      final items = groupedData[date]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DateSectionHeaderWidget(
                            date: date,
                            itemCount: items.length,
                          ),
                          ...items.map(
                            (item) => HistoryItemWidget(
                              historyData: item,
                              onViewMap: () => _handleViewMap(item),
                              onShare: () => _handleShare(item),
                              onAddNote: () => _handleAddNote(item),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              : EmptyStateWidget(
                  message: 'Great Safety Record!',
                  submessage: _selectedFilter == 'all'
                      ? 'No safety events recorded for this period'
                      : 'No $_selectedFilter risk events found',
                ),
        ),
      ],
    );
  }
}
