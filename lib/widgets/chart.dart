import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/common/color_constants.dart';

LineChartData mainData() {
  return LineChartData(
    gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 0.1,
          );
        }),
    titlesData: const FlTitlesData(
      bottomTitles: AxisTitles(),
      rightTitles: AxisTitles(),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    minX: 0,
    maxX: 8,
    minY: 0,
    maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: [
          const FlSpot(0, 3),
          const FlSpot(2.6, 2),
          const FlSpot(4.9, 5),
          const FlSpot(6.8, 3.1),
          const FlSpot(7, 4),
          const FlSpot(8, 3),
        ],
        isCurved: true,
        color: AppTheme.primaryColor,
        barWidth: 2,
        isStrokeCapRound: true,
      ),
    ],
  );
}
