import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WasteStatusRoseChart extends StatefulWidget {
  final Map<String, int> wasteStatusData;

  const WasteStatusRoseChart({super.key, required this.wasteStatusData});

  @override
  _WasteStatusRoseChartState createState() => _WasteStatusRoseChartState();
}

class _WasteStatusRoseChartState extends State<WasteStatusRoseChart> {
  int _touchedIndex = -1; // Track which pie section is clicked

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const Text(
          //   'Waste Request Statuses',
          //   style: TextStyle(
          //     fontSize: 18.0,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          // const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        _touchedIndex = -1;
                        return;
                      }
                      _touchedIndex = pieTouchResponse
                          .touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: _getChartSections(),
                centerSpaceRadius: 50,
                sectionsSpace: 5,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (_touchedIndex != -1)
            Text(
              _getTouchedStatusLabel(),
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _getChartSections() {
    final List<Color> colors = [
      const Color.fromARGB(255, 21, 120, 24),
      Colors.orange,
      Colors.blue,
      Colors.red,
      Colors.purple,
    ];

    final statusLabels = widget.wasteStatusData.keys.toList();
    final List<PieChartSectionData> sections = [];

    for (int i = 0; i < statusLabels.length; i++) {
      final statusLabel = statusLabels[i];
      final int count = widget.wasteStatusData[statusLabel] ?? 0;

      if (count > 0) {
        final bool isTouched = _touchedIndex == i;
        final double fontSize = isTouched ? 20.0 : 14.0;
        final double radius = isTouched ? 120.0 : 100.0;
        final double widgetSize = isTouched ? 55.0 : 40.0;
        const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

        sections.add(
          PieChartSectionData(
            color: colors[i % colors.length],
            value: count.toDouble(),
            title: '$count',
            radius: radius, // Highlight selected section
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              'assets/icons/status-icon-$i.svg', // Customize based on status
              size: widgetSize,
              borderColor: Colors.black,
            ),
            badgePositionPercentageOffset: .98,
          ),
        );
      }
    }

    return sections;
  }

  // Get the status label of the touched section
  String _getTouchedStatusLabel() {
    final statusLabels = widget.wasteStatusData.keys.toList();
    return statusLabels[_touchedIndex];
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });

  final String svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(.5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: const Center(
        child: Icon(Icons.check), // Placeholder for SVG, replace with actual SVG
      ),
    );
  }
}
