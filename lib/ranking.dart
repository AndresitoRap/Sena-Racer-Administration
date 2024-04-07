import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sena_racer_admin/models/runners.dart';
import 'package:http/http.dart' as http;

class Ranking extends StatelessWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color.fromARGB(255, 43, 158, 20);
    List<Runner> runner = [];

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
            int.parse(item['attributes']['score1'].toString()),
            int.parse(item['attributes']['score2'].toString()),
            int.parse(item['attributes']['score3'].toString()),
            int.parse(item['attributes']['score4'].toString()),
            int.parse(item['attributes']['score5'].toString()),
            int.parse(item['attributes']['time1'].toString()),
            int.parse(item['attributes']['time2'].toString()),
            int.parse(item['attributes']['time3'].toString()),
            int.parse(item['attributes']['time4'].toString()),
            int.parse(item['attributes']['time5'].toString()),
          ),
        );
      }
      return runner;
    }

    Map<int, double> calculateTimeAverages(List<Runner> times) {
      Map<int, double> averages = {};
      for (int i = 1; i <= 5; i++) {
        averages[i] = calculateTimeAverage(times, i);
      }
      return averages;
    }

    Map<int, double> calculateScoreAverages(List<Runner> scores) {
      Map<int, double> averages = {};
      for (int i = 1; i <= 5; i++) {
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
                  FutureBuilder<List<Runner>>(
                    future: getAllRunners(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Runner> times = snapshot.data!;
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
                  FutureBuilder<List<Runner>>(
                    future: getAllRunners(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator(color: primaryColor));
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        List<Runner> scores = snapshot.data!;
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
                  const SizedBox(height: 20),
                  const Text(
                    "Detalles",
                    style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: FutureBuilder<List<Runner>>(
                        future: getAllRunners(),
                        builder:
                            (context, AsyncSnapshot<List<Runner>> snapshot) {
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
                          } else if (snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text(
                              "No hay corredores aún",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ));
                          } else {
                            List<Runner> sortedRunners = snapshot.data!;
                            sortedRunners.sort((a, b) => (b.score1 +
                                    b.score2 +
                                    b.score3 +
                                    b.score4 + b.score5)
                                .compareTo(
                                    a.score1 + a.score2 + a.score3 + a.score4 + b.score5));
                            return SizedBox(
                              height: MediaQuery.of(context).size.height - 100,
                              width: MediaQuery.of(context).size.width - 100,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: DataTable(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  dividerThickness: 1,
                                  columns: const [
                                    DataColumn(
                                        label: Text(
                                      'Puesto',
                                      style: TextStyle(color: primaryColor),
                                    )),
                                    DataColumn(
                                        label: Text(
                                      'Identificación',
                                      style: TextStyle(color: primaryColor),
                                    )),
                                    DataColumn(
                                        label: Text('Nombre',
                                            style: TextStyle(
                                                color: primaryColor))),
                                    DataColumn(
                                        label: Text('Apellido',
                                            style: TextStyle(
                                                color: primaryColor))),
                                    DataColumn(
                                        label: Text('Puntajes c/e',
                                            style: TextStyle(
                                                color: primaryColor))),
                                    DataColumn(
                                        label: Text('Puntaje',
                                            style: TextStyle(
                                                color: primaryColor))),
                                    DataColumn(
                                        label: Text('Tiempos c/e',
                                            style: TextStyle(
                                                color: primaryColor))),
                                    DataColumn(
                                        label: Text('Tiempo',
                                            style: TextStyle(
                                                color: primaryColor))),
                                  ],
                                  rows: sortedRunners.map((data) {
                                    
                                    int rank = sortedRunners.indexOf(data) + 1;
                                    return DataRow(cells: [
                                      DataCell(Text(rank.toString())),
                                      DataCell(
                                          Text(data.identification.toString())),
                                      DataCell(Text(data.name)),
                                      DataCell(Text(data.lastName)),
                                      DataCell(MoreInfo(
                                          data1: data.score1,
                                          data2: data.score2,
                                          data3: data.score3,
                                          data4: data.score4, data5: data.score5)),
                                      DataCell(Text((data.score1 +
                                              data.score2 +
                                              data.score3 +
                                              data.score4 + data.score5)
                                          .toString())),
                                      DataCell(MoreInfo(
                                        data1: data.time1,
                                        data2: data.time2,
                                        data3: data.time3,
                                        data4: data.time4,
                                        data5: data.time5,
                                      )),
                                      DataCell(Text((data.time1 +
                                              data.time2 +
                                              data.time3 +
                                              data.time4 + data.time5)
                                          .toString())),
                                    ]);
                                  }).toList(),
                                ),
                              ),
                            );
                          }
                        },
                      ),
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

  double calculateTimeAverage(List<Runner> times, int station) {
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
        case 5:
          totalTime += time.time5;
          break;
        default:
          break;
      }
      count++;
    }
    if (count == 0) return 0;
    return totalTime / count;
  }

  double calculateScoreAverage(List<Runner> scores, int station) {
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
        case 5:
          totalScore += score.score5;
          break;
        default:
          break;
      }
      count++;
    }
    if (count == 0) return 0;
    return totalScore / count;
  }

  double calculateTimeTotal(List<Runner> times, int station) {
    double totalTime = 0;
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
        case 5:
          totalTime += time.time5;
          break;
        default:
          break;
      }
    }
    return totalTime;
  }

  double calculateScoreTotal(List<Runner> scores, int station) {
    double totalScore = 0;
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
        case 5:
          totalScore += score.score5;
          break;
        default:
          break;
      }
    }
    return totalScore;
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
          "(1) Estación Cunicultura",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 2:
        text = const Text(
          "(2) Estación Apicultura",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 3:
        text = const Text(
          "(3) Estación Porcinos",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 4:
        text = const Text(
          "(4) Estacion Ganaderia",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 5:
        text = const Text(
          "(5) Estacion SENA",
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
          "(1) Estación Cunicultura",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 2:
        text = const Text(
          "(2) Estación Apicultura",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 3:
        text = const Text(
          "(3) Estación Porcinos",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case 4:
        text = const Text(
          "(4) Estacion Ganaderia",
          style: style,
          overflow: TextOverflow.ellipsis,
        );
        break;
        case 5:
        text = const Text(
          "(5) Estacion SENA",
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

class MoreInfo extends StatelessWidget {
  const MoreInfo({
    super.key,
    required this.data1,
    required this.data2,
    required this.data3,
    required this.data4,
    required this.data5,
  });

  final int data1;
  final int data2;
  final int data3;
  final int data4;
  final int data5;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Tooltip(
          message: "Cunicultura", // Texto para time4
          child: Text(
            "$data1, ",
          ),
        ),
        Tooltip(
          message: "Apicultura", // Texto para time4
          child: Text(
            "$data2, ",
          ),
        ),
        Tooltip(
          message: "Porcinos", // Texto para time4
          child: Text(
            "$data3, ",
          ),
        ),
        Tooltip(
          message: "Ganaderia", // Texto para time4
          child: Text(
            "$data4, ",
          ),
        ),
        Tooltip(
          message: "SENA", // Texto para time4
          child: Text(
            "$data5",
          ),
        ),
      ],
    );
  }
}
