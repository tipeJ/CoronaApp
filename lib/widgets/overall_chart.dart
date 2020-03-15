import 'package:charts_flutter/flutter.dart' as charts;
import 'package:coronapp/models/models.dart';
import 'package:coronapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverAllStatsChart extends StatelessWidget {
  final bool animate;

  const OverAllStatsChart({this.animate});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      child: Card(
        child: Consumer<OverviewStatsProvider>(
          builder: (_, provider, child) {
            if (provider.stats != null) {
              return Padding(
                padding: const EdgeInsets.all(0.0),
                child: charts.TimeSeriesChart(
                  _createData(provider.stats.dailyStats),
                  animate: animate,
                  dateTimeFactory: const charts.LocalDateTimeFactory(),
                )
              );
            }
            return const SizedBox();
          }
        )
      )
    );
  }

  List<charts.Series<DailyStats, DateTime>> _createData(List<DailyStats> dailyStats) {
    return [
      new charts.Series<DailyStats, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (DailyStats stats, _) => stats.reportDate,
        measureFn: (DailyStats stats, _) => stats.totalConfirmed,
        data: dailyStats,
      ),
      new charts.Series<DailyStats, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (DailyStats stats, _) => stats.reportDate,
        measureFn: (DailyStats stats, _) => stats.totalRecovered,
        data: dailyStats,
      ),
    ];
  }
}