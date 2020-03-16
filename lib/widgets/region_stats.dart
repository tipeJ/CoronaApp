import 'package:coronapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:coronapp/resources/resources.dart';

class RegionStatsCard extends StatelessWidget {
  final RegionStats stats;

  const RegionStatsCard({this.stats, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(stats.countryRegion, style: Theme.of(context).textTheme.headline),
                  stats.provinceState != null
                    ? Text(stats.provinceState, style: Theme.of(context).textTheme.subhead)
                    : null,
                  const SizedBox(height: 3.5),
                  Text("Recovered: ${stats.recovered}", style: TextStyle(color: Colors.greenAccent)),
                  Text("Active: ${stats.active}"),
                  Text("Deaths: ${stats.deaths}", style: TextStyle(color: Colors.redAccent)),
                ].nonNulls(),
              ),
              Text(stats.confirmed.toString(), style: Theme.of(context).textTheme.title)
            ]
          ),
          const Divider()
        ]
      )
    );
  }
}