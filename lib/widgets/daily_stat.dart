import 'package:CoronaApp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyStatCard extends StatelessWidget {
  const DailyStatCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Consumer<OverviewStatsProvider>(
        builder: (_, provider, child) => Container(
          height: 75.0,
          padding: const EdgeInsets.all(10.0),
          child: provider.stats != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${provider.stats.dailyStats.first.deltaConfirmed} New Cases Today", style: Theme.of(context).textTheme.headline),
                Text("${provider.stats.dailyStats.first.deltaRecovered} Recoveries", style: Theme.of(context).textTheme.subhead.apply(color: Colors.greenAccent)),
              ]
            )
          : const SizedBox()
        )
      )
    );
  }
}