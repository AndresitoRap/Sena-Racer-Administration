import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sena_racer_admin/models/runners.dart';
import 'package:sena_racer_admin/models/score.dart';
import 'package:sena_racer_admin/models/time.dart';
import 'package:http/http.dart' as http;

class Ranking extends StatelessWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 43, 158, 20);
    List<Time> times = [];
    List<Score> scores = [];
    List<Runner> runner = [];

    Future<List<Time>> getAllTimes() async {
      var response = await http.get(Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/tiempos/"));

      if (response.statusCode == 200) {
        times.clear();
      }

      final Map<String, dynamic> decodedData = jsonDecode(response.body);
      final Iterable timeData = decodedData.values;

      for (var item in timeData.elementAt(0)) {
        times.add(
          Time(
            item['id'],
            item['attributes']['time1'] ?? 0,
            item['attributes']['time2'],
            item['attributes']['time3'],
            item['attributes']['time4'],
          ),
        );
      }
      return times;
    }

    Future<List<Score>> getAllScores() async {
      var response = await http.get(Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/scores/"));

      if (response.statusCode == 200) {
        scores.clear();
      }

      Map<String, dynamic> decodedData = jsonDecode(response.body);
      Iterable scoreData = decodedData.values;

      for (var item in scoreData.elementAt(0)) {
        scores.add(
          Score(
            item['id'],
            int.parse(item['attributes']['score1'] ?? 0),
            int.parse(item['attributes']['score2'] ?? 0),
            int.parse(item['attributes']['score3'] ?? 0),
            int.parse(item['attributes']['score4'] ?? 0),
          ),
        );
      }
      return scores;
    }

    Future<List<Runner>> getAllRunners() async {
      var response = await http.get(Uri.parse(
          "https://backend-strapi-senaracer.onrender.com/api/runners/"));

      if (response.statusCode == 200) {
        runner.clear();
      }

      Map<String, dynamic> decodedData = jsonDecode(response.body);
      Iterable runnersData = decodedData.values;

      for (var item in runnersData.elementAt(0)) {
        runner.add(
          Runner(
            int.parse(item['id'].toString()),
            item['attributes']['name'],
            item['attributes']['lastname'],
            int.parse(item['attributes']['identification'].toString()),
            item['attributes']['password'],
          ),
        );
      }
      return runner;
    }

    Map<int, double> calculateTimeAverages(List<Time> times) {
      Map<int, double> averages = {};
      for (int i = 1; i <= 4; i++) {
        averages[i] = calculateTimeAverage(times, i);
      }
      return averages;
    }

    Map<int, double> calculateScoreAverages(List<Score> scores) {
      Map<int, double> averages = {};
      for (int i = 1; i <= 4; i++) {
        averages[i] = calculateScoreAverage(scores, i);
      }
      return averages;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  const Text(
                    "Tiempo por cada estación",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  FutureBuilder<List<Time>>(
                    future: getAllTimes(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Time> times = snapshot.data!;
                        Map<int, double> timeAverages =
                            calculateTimeAverages(times);

                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SizedBox(
                            height: 500,
                            child: BarChart(
                              BarChartData(
                                maxY: 100,
                                minY: 0,
                                groupsSpace: 1,
                                gridData: const FlGridData(show: true),
                                borderData: FlBorderData(show: true),
                                titlesData: FlTitlesData(
                                  show: true,
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: getBottomtitletime,
                                    ),
                                  ),
                                ),
                                barGroups: [
                                  for (var entry in timeAverages.entries)
                                    BarChartGroupData(
                                      x: entry.key.toDouble().toInt(),
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value,
                                          color: primaryColor,
                                          width: 35,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          backDrawRodData:
                                              BackgroundBarChartRodData(
                                            show: true,
                                            toY: 1,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Puntaje por cada estación",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  FutureBuilder<List<Score>>(
                    future: getAllScores(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Score> scores = snapshot.data!;
                        Map<int, double> scoreAverages =
                            calculateScoreAverages(scores);

                        return Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SizedBox(
                            height: 500,
                            child: BarChart(
                              BarChartData(
                                maxY: 200,
                                minY: 0,
                                groupsSpace: 1,
                                gridData: const FlGridData(show: true),
                                borderData: FlBorderData(show: true),
                                titlesData: FlTitlesData(
                                  show: true,
                                  topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: getBottomtitlescore,
                                    ),
                                  ),
                                ),
                                barGroups: [
                                  for (var entry in scoreAverages.entries)
                                    BarChartGroupData(
                                      x: entry.key.toDouble().toInt(),
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value,
                                          color: primaryColor,
                                          width: 35,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          backDrawRodData:
                                              BackgroundBarChartRodData(
                                            show: true,
                                            toY: 1,
                                            color: Colors.grey[200],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Runner>>(
                      future: getAllRunners(),
                      builder: (context, AsyncSnapshot<List<Runner>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 43, 158, 20)),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                            ),
                          );
                        } else if (snapshot.data == null) {
                          return const Center(
                            child: Text('No se encontraron corredores.'),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.red,
                                        height: 200,
                                        width: 200,
                                        child: Text(snapshot.data![index].name),
                                      ),
                                    );
                                  }),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  double calculateTimeAverage(List<Time> times, int station) {
    double totalTime = 0;
    int count = 0;
    for (var time in times) {
      switch (station) {
        case 1:
          totalTime += time.time1;
          break;
        case 2:
          totalTime += time.time2;
          break;
        case 3:
          totalTime += time.time3;
          break;
        case 4:
          totalTime += time.time4;
          break;
        default:
          break;
      }
      count++;
    }
    if (count == 0) return 0;
    return totalTime / count;
  }

  double calculateScoreAverage(List<Score> scores, int station) {
    double totalScore = 0;
    int count = 0;
    for (var score in scores) {
      switch (station) {
        case 1:
          totalScore += score.score1;
          break;
        case 2:
          totalScore += score.score2;
          break;
        case 3:
          totalScore += score.score3;
          break;
        case 4:
          totalScore += score.score4;
          break;
        default:
          break;
      }
      count++;
    }
    if (count == 0) return 0;
    return totalScore / count;
  }

  Widget getBottomtitlescore(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );

    late Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text(
          "Estación Gananderia",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 2:
        text = const Text(
          "Estación Apicultura",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 3:
        text = const Text(
          "Estación Porcinos",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 4:
        text = const Text(
          "Estacion Ganaderia",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      default:
        text = const Text("Error");
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }

  Widget getBottomtitletime(
    double value,
    TitleMeta meta,
  ) {
    const style = TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 10);

    late Widget text;
    switch (value.toInt()) {
      case 1:
        text = const Text(
          "Estación Gananderia",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 2:
        text = const Text(
          "Estación Apicultura",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 3:
        text = const Text(
          "Estación Porcinos",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 4:
        text = const Text(
          "Estacion Ganaderia",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      default:
        text = const Text("Error");
    }
    return SideTitleWidget(axisSide: meta.axisSide, child: text);
  }
}
