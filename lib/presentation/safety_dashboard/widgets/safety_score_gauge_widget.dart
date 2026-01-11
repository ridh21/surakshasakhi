import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'dart:math' as math;

class SafetyScoreGaugeWidget extends StatelessWidget {
  final int score;
  final bool isRefreshing;

  const SafetyScoreGaugeWidget({
    super.key,
    required this.score,
    this.isRefreshing = false,
  });

  Color _getScoreColor(BuildContext context, int score) {
    final theme = Theme.of(context);
    if (score <= 30) return theme.colorScheme.secondary; // Green - Low risk
    if (score <= 60) return const Color(0xFFF0B865); // Yellow - Moderate
    if (score <= 80) return const Color(0xFFE89560); // Orange - High
    return theme.colorScheme.error; // Red - Critical
  }

  String _getRiskLevel(int score) {
    if (score <= 30) return 'Low Risk';
    if (score <= 60) return 'Moderate Risk';
    if (score <= 80) return 'High Risk';
    return 'Critical Risk';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scoreColor = _getScoreColor(context, score);
    final riskLevel = _getRiskLevel(score);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        color: scoreColor.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scoreColor.withValues(alpha: 0.2), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'Live Safety Score',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3.h),

          // Circular Gauge
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 50.w,
                height: 50.w,
                child: CustomPaint(
                  painter: _GaugePainter(
                    score: score,
                    color: scoreColor,
                    backgroundColor: theme.colorScheme.outline.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    score.toString(),
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: scoreColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 48.sp,
                    ),
                  ),
                  Text(
                    riskLevel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (isRefreshing)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.scaffoldBackgroundColor.withValues(
                        alpha: 0.7,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(color: scoreColor),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 3.h),

          // Score Range Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRangeIndicator(
                context,
                '0-30',
                'Low',
                theme.colorScheme.secondary,
              ),
              _buildRangeIndicator(
                context,
                '31-60',
                'Moderate',
                const Color(0xFFF0B865),
              ),
              _buildRangeIndicator(
                context,
                '61-80',
                'High',
                const Color(0xFFE89560),
              ),
              _buildRangeIndicator(
                context,
                '81-100',
                'Critical',
                theme.colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRangeIndicator(
    BuildContext context,
    String range,
    String label,
    Color color,
  ) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }
}

class _GaugePainter extends CustomPainter {
  final int score;
  final Color color;
  final Color backgroundColor;

  _GaugePainter({
    required this.score,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 12.0;

    // Background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Score arc
    final scorePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -math.pi / 2,
      sweepAngle,
      false,
      scorePaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.score != score || oldDelegate.color != color;
  }
}
