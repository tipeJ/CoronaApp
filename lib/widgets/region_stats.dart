import 'package:CoronaApp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:CoronaApp/resources/resources.dart';

class RegionStatsCard extends StatelessWidget {
  final RegionStats stats;
  final VoidCallback onTap;

  const RegionStatsCard({this.stats, this.onTap, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
      )
    );
  }
}