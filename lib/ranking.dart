import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sena_racer_admin/bar_graph/bar_graph.dart';

class Ranking extends StatelessWidget {
  const Ranking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<double> time = [
      10.40,
      20.50,
      190.5,
      100.20,
    ];
    List<double> score = [
      100,
      30,
      70,
      120,
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: MyBarGraph(
              time: time,
              score: score,
            ),
          ),
        ],
      ),
    );
  }
}
