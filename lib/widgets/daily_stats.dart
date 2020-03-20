import 'package:CoronaApp/models/models.dart';
import 'package:flutter/material.dart';

class DailyStatsCard extends StatelessWidget {
  final DailyStats stats;

  const DailyStatsCard({this.stats, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Mainland China: ${stats.mainlandChina}"),
              Text("Outside China: ${stats.otherLocations}"),
              Text("Total Recovered: ${stats.totalRecovered}"),
            ],
          ),
          Text(stats.totalConfirmed.toString(), style: Theme.of(context).textTheme.title)
        ]
      )
    );
  }
}