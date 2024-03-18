// ignore_for_file: file_names

import 'package:sena_racer_admin/bar_graph/individual_bar.dart';

class Score {
  int id;
  int score1;
  int score2;
  int score3;
  int score4;

  Score(
    this.id,
    this.score1,
    this.score2,
    this.score3,
    this.score4,
  );

  List<IndividualBar> bardata = [];

  void initialzeBarData() {
    bardata = [
      IndividualBar(x: 0, y: score1),
      IndividualBar(x: 1, y: score2),
      IndividualBar(x: 2, y: score3),
      IndividualBar(x: 3, y: score4),
    ];
  }
}