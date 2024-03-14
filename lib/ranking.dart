import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sena_racer_admin/bar_graph/bar_graph.dart';

class Ranking extends StatefulWidget {
  const Ranking({
    super.key,
  });

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  List<double> weeklySummary = [
    10.40,
    20.50,
    190.5,
    100.20,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 300,
        height: 400,
        child: MyBarGraph(
          weeklySummary: weeklySummary,
        ),
      ),
    );
  }
}
