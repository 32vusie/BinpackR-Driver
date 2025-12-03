import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample7 extends StatelessWidget {
  const BarChartSample7({super.key, required this.dataList});

  final List<_BarData> dataList;
  final Color shadowColor = const Color(0xFFCCCCCC);

  BarChartGroupData generateBarGroup(
    int x,
    Color color,
    double value,
    double shadowValue,
  ) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: color,
          width: 6,
        ),
        BarChartRodData(
          toY: shadowValue,
          color: shadowColor,
          width: 6,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: AspectRatio(
        aspectRatio: 1.4,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
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
                  reservedSize: 30,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      textAlign: TextAlign.left,
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  // getTitlesWidget: (value, meta) {
                  //   final index = value.toInt();
                  //   // return SideTitleWidget(
                  //   //   axisSide: meta.axisSide,
                  //   //   meta: ,
                  //   //   child: _IconWidget(
                  //   //     color: dataList[index].color,
                  //   //     isSelected: false, // You can add logic to highlight selected bar
                  //   //   ),
                  //   // );
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
            barGroups: dataList.asMap().entries.map((e) {
              final index = e.key;
              final data = e.value;
              return generateBarGroup(
                index,
                data.color,
                data.value,
                data.shadowValue,
              );
            }).toList(),
            maxY: dataList.map((d) => d.value).reduce((a, b) => a > b ? a : b) + 10,
          ),
        ),
      ),
    );
  }
}

class _BarData {
  const _BarData(this.color, this.value, this.shadowValue);
  final Color color;
  final double value;
  final double shadowValue;
}

class _IconWidget extends StatelessWidget {
  const _IconWidget({
    required this.color,
    required this.isSelected,
  });

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Icon(
      isSelected ? Icons.face_retouching_natural : Icons.face,
      color: color,
      size: 28,
    );
  }
}
