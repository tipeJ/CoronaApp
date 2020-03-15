import 'package:coronapp/models/models.dart';
import 'package:flutter/material.dart';

class DailyStatsCard extends StatelessWidget {
  final DailyStats stats;

  const DailyStatsCard({this.stats, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Text("Mainland China: ${stats.mainlandChina}"),
          Text("Outside China: ${stats.otherLocations}"),
          Text("Total Confirmed: ${stats.totalConfirmed}"),
          Text("Total Recovered: ${stats.totalRecovered}"),
        ],
      )
    );
  }
}