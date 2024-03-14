import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sena_racer_admin/bar_graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    BarData mybarData = BarData(
      station1: weeklySummary[0],
      station2: weeklySummary[1],
      station3: weeklySummary[2],
      station4: weeklySummary[3],
    );
    mybarData.initialzeBarData();
    return BarChart(
      BarChartData(
        maxY: 200,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        barGroups: mybarData.bardata
            .map(
              (data) => BarChartGroupData(x: data.x, barRods: [
                BarChartRodData(
                  toY: data.y,
                  color: primaryColor,
                  width: 25,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: 100,
                    color: Colors.grey[200],
                  ),
                ),
              ]),
            )
            .toList(),
      ),
    );
  }
}
