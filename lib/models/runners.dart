// Definición de la clase Runner
import 'package:sena_racer_admin/models/score.dart';
import 'package:sena_racer_admin/models/time.dart';

class Runner {
  int id;
  String name;
  String lastName;
  int identification;
  String password;
  List<Time> times;
  List<Score> scores;

  Runner(
    this.id,
    this.name,
    this.lastName,
    this.identification,
    this.password,
    this.times, 
    this.scores
  );

  
}
