import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:genius_ai/model/price_history_response.dart';

class SurfaceChart extends StatelessWidget {
  final PriceHistoryResponse history;

  const SurfaceChart({super.key, required this.history});

  // ─── Dynamic Y max from real data ───────────────────────────────────────────
  double get _maxY {
    double max = 0;
    for (final item in history.data) {
      for (final price in item.prices) {
        if (price > max) max = price;
      }
    }
    // Fallback if all prices are zero
    return max == 0 ? 100 : (max * 1.25).ceilToDouble();
  }

  double get _yInterval {
    final interval = (_maxY / 4).ceilToDouble();
    return interval > 0 ? interval : 25;
  }

  // ─── Check if any supplier has data ─────────────────────────────────────────
  bool get _hasAnyData {
    for (final item in history.data) {
      if (item.prices.any((p) => p > 0)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final List<Color> lineColors = [
      const Color(0xFF7E57C2), // Purple  - ABC Imports
      const Color(0xFF0FCA4D), // Green   - Imported Supplier
      const Color(0xFF42A5F5), // Blue    - Ocean Fresh
    ];

    // ─── Show empty state if truly no data ────────────────────────────────────
    if (!_hasAnyData) {
      return SizedBox(
        height: 300,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.bar_chart_outlined,
                size: 48,
                color: Colors.blueGrey.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 8),
              Text(
                'No price data available',
                style: TextStyle(
                  color: Colors.blueGrey.withValues(alpha: 0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Chart ────────────────────────────────────────────────────────────
        SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 8),
            child: LineChart(
              LineChartData(
                clipData: const FlClipData.all(),

                // ─── Grid ────────────────────────────────────────────────────
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: _yInterval,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.blueGrey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: Colors.blueGrey.withValues(alpha: 0.2),
                    strokeWidth: 1,
                    dashArray: [5, 5],
                  ),
                  // ✅ KEY FIX: show vertical line every 5 data points
                  checkToShowVerticalLine: (value) {
                    return value == 0 ||
                        value.toInt() % 5 == 0 &&
                            value <= history.labels.length - 1;
                  },
                ),

                // ─── Titles ──────────────────────────────────────────────────
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _yInterval,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        // Hide min and max auto-labels from fl_chart
                        if (value == meta.min || value == meta.max) {
                          return const SizedBox();
                        }
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 11,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 32,
                      getTitlesWidget: (value, meta) {
                        final int index = value.toInt();
                        if (index < 0 || index >= history.labels.length) {
                          return const SizedBox();
                        }
                        // ✅ Show label at index 0 and every 5th index
                        if (index == 0 || index % 5 == 0) {
                          final DateTime date = DateTime.parse(
                            history.labels[index],
                          );
                          final String text = DateFormat('MMM d').format(date);
                          return Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              text,
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),

                // ─── Border ──────────────────────────────────────────────────
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.blueGrey.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    left: BorderSide(
                      color: Colors.blueGrey.withValues(alpha: 0.4),
                      width: 2,
                    ),
                    top: BorderSide.none,
                    right: BorderSide.none,
                  ),
                ),

                // ─── Scale ───────────────────────────────────────────────────
                minX: 0,
                maxX: (history.labels.length - 1).toDouble(),
                minY: 0,
                maxY: _maxY,

                // ─── Lines ───────────────────────────────────────────────────
                lineBarsData: history.data.asMap().entries.map((entry) {
                  return _generateLine(
                    lineColors[entry.key % lineColors.length],
                    entry.value.prices,
                  );
                }).toList(),
              ),
            ),
          ),
        ),

        // ─── Legend ───────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Wrap(
            spacing: 16,
            runSpacing: 6,
            children: history.data.asMap().entries.map((entry) {
              final color = lineColors[entry.key % lineColors.length];
              final name = entry.value.supplierName;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 11,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  LineChartBarData _generateLine(Color color, List<double> prices) {
    final spots = prices
        .asMap()
        .entries
        .where((e) => e.value > 0)
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    // ✅ Single point: show dot only, no line, no fill
    final bool isSinglePoint = spots.length <= 1;

    return LineChartBarData(
      spots: spots,
      isCurved: !isSinglePoint,
      curveSmoothness: 0.35,
      color: color,
      barWidth: isSinglePoint ? 0 : 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
          radius: isSinglePoint ? 6 : 4, // ✅ Bigger dot for isolated points
          color: color,
          strokeWidth: 2,
          strokeColor: Colors.white,
        ),
      ),
      belowBarData: BarAreaData(
        show: !isSinglePoint,
        color: color.withValues(alpha: 0.08),
      ),
    );
  }
}
