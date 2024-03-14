import 'package:sena_racer_admin/bar_graph/individual_bar.dart';

class BarData {
  final double station1;
  final double station2;
  final double station3;
  final double station4;

  BarData({
    required this.station1,
    required this.station2,
    required this.station3,
    required this.station4,
  });

  List<IndividualBar> bardata = [];

  void initialzeBarData() {
    bardata = [
      IndividualBar(x: 0, y: station1),
      IndividualBar(x: 1, y: station2),
      IndividualBar(x: 2, y: station3),
      IndividualBar(x: 3, y: station4),
    ];
  }
}
