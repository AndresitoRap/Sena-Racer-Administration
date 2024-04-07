// Definición de la clase Runner

import 'package:sena_racer_admin/bar_graph/individual_bar.dart';

class Runner {
  int id;
  String name;
  String lastName;
  int identification;
  String password;
  int score1;
  int score2;
  int score3;
  int score4;
  int score5;
  int time1;
  int time2;
  int time3;
  int time4;
  int time5;

  Runner(
    this.id,
    this.name,
    this.lastName,
    this.identification,
    this.password,
    this.score1,
    this.score2,
    this.score3,
    this.score4,
    this.score5,
    this.time1,
    this.time2,
    this.time3,
    this.time4,
    this.time5,
  );

  List<IndividualBar> bardatascore = [];

  void initialzeBarDataScore() {
    bardatascore = [
      IndividualBar(x: 0, y: score1),
      IndividualBar(x: 1, y: score2),
      IndividualBar(x: 2, y: score3),
      IndividualBar(x: 3, y: score4),
      IndividualBar(x: 3, y: score5),
    ];
  }

  List<IndividualBar> bardatatime = [];

  void initialzeBarDataTime() {
    bardatatime = [
      IndividualBar(x: 0, y: time1),
      IndividualBar(x: 1, y: time2),
      IndividualBar(x: 2, y: time3),
      IndividualBar(x: 3, y: time4),
      IndividualBar(x: 3, y: time5),
    ];
  }
}
