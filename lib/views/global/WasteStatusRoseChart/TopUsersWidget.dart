import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class TopUsersWidget extends StatefulWidget {
  final Map<String, double> userRequestData;

  const TopUsersWidget({super.key, required this.userRequestData});

  @override
  _TopUsersWidgetState createState() => _TopUsersWidgetState();
}

class _TopUsersWidgetState extends State<TopUsersWidget> {
  int touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    final sortedEntries = widget.userRequestData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topUsers = sortedEntries.take(6).toList();

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Users',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround, // Adjust spacing
                borderData: FlBorderData(
                  show: true,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    drawBelowEverything: true,
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 14),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      // getTitlesWidget: (value, meta) {
                      //   final index = value.toInt();
                      //   final userNames = topUsers.map((e) => e.key).toList();
                      //   return SideTitleWidget(
                      //     axisSide: meta.axisSide,
                      //     child: _IconWidget(
                      //       label: userNames[index],
                      //       isSelected: touchedGroupIndex == index,
                      //     ),
                      //   );
                      // },
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.2),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: _generateBarGroups(topUsers),
                maxY: topUsers
                        .map((e) => e.value)
                        .reduce((a, b) => a > b ? a : b) *
                    1.2,
                barTouchData: BarTouchData(
                  enabled: true,
                  handleBuiltInTouches: false,
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (group) => Colors.transparent,
                    tooltipMargin: 0,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      return BarTooltipItem(
                        rod.toY.toString(),
                        TextStyle(
                          fontWeight: FontWeight.bold,
                          color: rod.color,
                          fontSize: 18,
                          shadows: const [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 12,
                            )
                          ],
                        ),
                      );
                    },
                  ),
                  touchCallback: (event, response) {
                    if (event.isInterestedForInteractions &&
                        response != null &&
                        response.spot != null) {
                      setState(() {
                        touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                      });
                    } else {
                      setState(() {
                        touchedGroupIndex = -1;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups(
      List<MapEntry<String, double>> topUsers) {
    final List<Color> colors = [
      Colors.blue,
      Colors.orange,
      const Color.fromARGB(255, 8, 116, 13),
      Colors.red,
      Colors.purple,
      Colors.teal,
    ];

    return topUsers.asMap().entries.map((entry) {
      final index = entry.key;
      final user = entry.value.value;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: user,
            color: colors[index % colors.length],
            width: 16, // Adjust width
          ),
          BarChartRodData(
            toY: user * 0.9, // Shadow Value
            color: Colors.grey.withOpacity(0.3),
            width: 16, // Adjust width
          ),
        ],
        showingTooltipIndicators: touchedGroupIndex == index ? [0] : [],
      );
    }).toList();
  }
}

class _IconWidget extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _IconWidget({
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scale = isSelected ? 1.5 : 1.0;
    return Transform.scale(
      scale: scale,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: isSelected ? Colors.blue : Colors.black,
        ),
      ),
    );
  }
}
