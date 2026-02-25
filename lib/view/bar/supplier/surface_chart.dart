import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SurfaceChart extends StatelessWidget {
  const SurfaceChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          // 1. Grid Configuration
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 10,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.blueGrey.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [5, 5], // Creates the dashed effect
            ),
            getDrawingVerticalLine: (value) => FlLine(
              color: Colors.blueGrey.withOpacity(0.2),
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          // 2. Axis Titles and Styling
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                ),
                reservedSize: 30,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  // Custom logic for the "Jan 10" vs "Jan 16" labels
                  String text = value == 0 ? 'Jan 10' : 'Jan 16';
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(text, style: const TextStyle(color: Colors.blueGrey, fontSize: 12)),
                  );
                },
                reservedSize: 30,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 2),
              left: BorderSide(color: Colors.blueGrey.withOpacity(0.5), width: 2),
            ),
          ),
          // 3. Data Ranges
          minX: 0,
          maxX: 5,
          minY: 0,
          maxY: 40,
          lineBarsData: [
            _generateLine(const Color(0xFF7E57C2), [39, 39, 38, 39, 38, 38]), // Purple
            _generateLine(const Color.fromARGB(255, 15, 202, 77), [34, 35, 36, 35, 35, 35]), // Green
            _generateLine(const Color(0xFF42A5F5), [31, 32, 33, 33, 32, 32]), // Blue
          ],
        ),
      ),
    );
  }

  LineChartBarData _generateLine(Color color, List<double> spots) {
    return LineChartBarData(
      spots: spots.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
      isCurved: true,
      curveSmoothness: 0.35,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: 4,
          color: color,
          strokeWidth: 0,
        ),
      ),
      // areaData: FlAreaData(show: false),
    );
  }
}