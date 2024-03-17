import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sena_racer_admin/bar_graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List time;
  final List score;
  final primaryColor = const Color.fromARGB(255, 43, 158, 20);
  const MyBarGraph({super.key, required this.time, required this.score});

  @override
  Widget build(BuildContext context) {
    BarData bardataTime = BarData(
      station1: time[0],
      station2: time[1],
      station3: time[2],
      station4: time[3],
    );
    BarData bardataScore = BarData(
      station1: score[0],
      station2: score[1],
      station3: score[2],
      station4: score[3],
    );
    bardataTime.initialzeBarData();
    bardataScore.initialzeBarData();
    return Scaffold(
        body: Column(
      children: [
        const Text("Tiempo por cada estación"),
        Expanded(
          child: SizedBox(
            height: 400,
            child: BarChart(
              BarChartData(
                maxY: 200,
                minY: 0,
                groupsSpace: 1,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, getTitlesWidget: getBottomTitleTime),
                  ),
                ),
                barGroups: bardataTime.bardata
                    .map(
                      (data) => BarChartGroupData(x: data.x, barRods: [
                        BarChartRodData(
                          toY: data.y,
                          color: primaryColor,
                          width: 35,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 1,
                            color: Colors.grey[200],
                          ),
                        ),
                      ]),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text("Puntaje por cada estación"),
        Expanded(
          child: SizedBox(
            height: 400,
            child: BarChart(
              BarChartData(
                maxY: 200,
                minY: 0,
                groupsSpace: 1,
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(
                  show: true,
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                        showTitles: true, getTitlesWidget: getBottomTitleScore),
                  ),
                ),
                barGroups: bardataScore.bardata
                    .map(
                      (data) => BarChartGroupData(x: data.x, barRods: [
                        BarChartRodData(
                          toY: data.y,
                          color: primaryColor,
                          width: 35,
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
            ),
          ),
        ),
      ],
    ));
  }
}

Widget getBottomTitleScore(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "E/Puntaje1",
        style: style,
      );
      break;
    case 1:
      text = const Text(
        "E/Puntaje2",
        style: style,
      );
      break;
    case 2:
      text = const Text(
        "E/Puntaje3",
        style: style,
      );
      break;
    case 3:
      text = const Text(
        "E/Puntaje4",
        style: style,
      );
      break;
    default:
      text = const Text("", style: style);
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}

Widget getBottomTitleTime(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text(
        "E/Tiempo1",
        style: style,
      );
      break;
    case 1:
      text = const Text(
        "E/Tiempo2",
        style: style,
      );
      break;
    case 2:
      text = const Text(
        "E/Tiempo3",
        style: style,
      );
      break;
    case 3:
      text = const Text(
        "E/Tiempo4",
        style: style,
      );
      break;
    default:
      text = const Text("", style: style);
  }
  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}
