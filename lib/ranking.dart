import 'package:flutter/material.dart';

class Ranking extends StatefulWidget {
  const Ranking({
    super.key,
  });

  @override
  State<Ranking> createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Center(
              child: Text("Ranking"),
            )
          ],
        ),
      ),
    );
  }
}
