import 'package:CoronaApp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:provider/provider.dart';

class StatsOverviewCountCard extends StatelessWidget {
  const StatsOverviewCountCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Card(
        child: Consumer<OverviewStatsProvider>(
          builder: (_, provider, child) {
            final stats = provider.stats;
            if (stats != null) {
              final overview = stats.overviewStats;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${overview.totalConfirmed} Confirmed Cases",
                          style: Theme.of(context).textTheme.title,
                        ),
                        Text.rich(
                          TextSpan(
                            style: Theme.of(context).textTheme.subhead..apply(fontSizeFactor: 0.6),
                            children: [
                              TextSpan(text: "${overview.totalDeaths} "),
                              TextSpan(
                                text: "Deaths ",
                                style: TextStyle(color: Colors.redAccent)
                              ),
                              TextSpan(text: "${overview.totalRecovered} "),
                              TextSpan(
                                text: "Recovered",
                                style: TextStyle(color: Colors.greenAccent)
                              )
                            ]
                          )
                        )
                      ]
                    ),
                    AnimatedCircularChart(
                      duration: const Duration(milliseconds: 1000),
                      size: const Size(50, 50),
                      initialChartData: [
                        CircularStackEntry([
                          CircularSegmentEntry(
                            1 - ((overview.totalDeaths + overview.totalRecovered) / overview.totalConfirmed),
                            Colors.grey
                          ),
                          CircularSegmentEntry(
                            overview.totalDeaths / overview.totalConfirmed,
                            Colors.redAccent
                          ),
                          CircularSegmentEntry(
                            overview.totalRecovered / overview.totalConfirmed,
                            Colors.greenAccent
                          )
                        ])
                      ],
                    )
                  ],
                ),
              );
            }
            return const SizedBox();
          }
        ),
      )
    );
  }
}