import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/common/color_constants.dart';

LineChartData mainData() {
  return LineChartData(
    gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0xff37434d),
            strokeWidth: 0.1,
          );
        }),
    titlesData: FlTitlesData(
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
          FlSpot(0, 3),
          FlSpot(2.6, 2),
          FlSpot(4.9, 5),
          FlSpot(6.8, 3.1),
          FlSpot(7, 4),
          FlSpot(8, 3),
        ],
        isCurved: true,
        color: primary,
        barWidth: 2,
        isStrokeCapRound: true,
      ),
    ],
  );
}
