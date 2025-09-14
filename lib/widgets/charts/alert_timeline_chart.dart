import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class AlertTimelineChart extends StatelessWidget {
  final Map<DateTime, int> dailyData;
  final String title;
  final Color lineColor;

  const AlertTimelineChart({
    Key? key,
    required this.dailyData,
    required this.title,
    this.lineColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          final dates = dailyData.keys.toList()..sort();
                          if (value.toInt() < dates.length && value.toInt() >= 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                DateFormat('MM/dd').format(dates[value.toInt()]),
                                style: const TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: const TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _buildSpots(),
                      isCurved: true,
                      color: lineColor,
                      barWidth: 3,
                      belowBarData: BarAreaData(
                        show: true,
                        color: lineColor.withOpacity(0.2),
                      ),
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: lineColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: _getMaxY(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _buildSpots() {
    final dates = dailyData.keys.toList()..sort();
    return dates.asMap().entries.map((entry) {
      final date = entry.value;
      final count = dailyData[date] ?? 0;
      return FlSpot(entry.key.toDouble(), count.toDouble());
    }).toList();
  }

  double _getMaxY() {
    if (dailyData.isEmpty) return 10;
    final maxValue = dailyData.values.reduce((a, b) => a > b ? a : b);
    return (maxValue + 2).toDouble();
  }

  Widget _buildSummary() {
    final total = dailyData.values.fold(0, (sum, value) => sum + value);
    final average = dailyData.isNotEmpty ? total / dailyData.length : 0;
    final maxDay = dailyData.entries.isNotEmpty
        ? dailyData.entries.reduce((a, b) => a.value > b.value ? a : b)
        : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryItem('Total', total.toString(), Icons.bar_chart),
        _buildSummaryItem('Moyenne', average.toStringAsFixed(1), Icons.trending_up),
        if (maxDay != null)
          _buildSummaryItem(
            'Pic',
            '${maxDay.value} (${DateFormat('dd/MM').format(maxDay.key)})',
            Icons.trending_up,
          ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 16, color: lineColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: lineColor,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}