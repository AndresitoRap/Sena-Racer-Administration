// ignore_for_file: file_names

import 'package:sena_racer_admin/bar_graph/individual_bar.dart';

class Time {
  int id;
  int time1;
  int time2;
  int time3;
  int time4;

  Time(
    this.id,
    this.time1,
    this.time2,
    this.time3,
    this.time4,
  );

  List<IndividualBar> bardata = [];

  void initialzeBarData() {
    bardata = [
      IndividualBar(x: 0, y: time1),
      IndividualBar(x: 1, y: time2),
      IndividualBar(x: 2, y: time3),
      IndividualBar(x: 3, y: time4),
    ];
  }
}