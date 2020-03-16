import 'package:charts_flutter/flutter.dart' as charts;
import 'package:coronapp/models/models.dart';
import 'package:coronapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverAllStatsChart extends StatelessWidget {
  final bool animate;

  const OverAllStatsChart({this.animate});

  static const _marginSpecPixelsMin = 20;
  static const _marginSpecPixelsMax = 35;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250.0,
      child: Consumer<OverviewStatsProvider>(
        builder: (_, provider, child) {
          if (provider.stats != null) {
            return Padding(
              padding: const EdgeInsets.all(0.0),
              child: charts.TimeSeriesChart(
                _createData(provider.stats.dailyStats),
                animate: animate,
                layoutConfig: charts.LayoutConfig(
                  leftMarginSpec: charts.MarginSpec.fromPixel(minPixel: 35, maxPixel: 50),
                  rightMarginSpec: charts.MarginSpec.fromPixel(minPixel: _marginSpecPixelsMin, maxPixel: _marginSpecPixelsMax),
                  topMarginSpec: charts.MarginSpec.fromPixel(minPixel: _marginSpecPixelsMin, maxPixel: _marginSpecPixelsMax),
                  bottomMarginSpec: charts.MarginSpec.fromPixel(minPixel: _marginSpecPixelsMin, maxPixel: _marginSpecPixelsMax),
                ),
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              )
            );
          }
          return const SizedBox();
        }
      )
    );
  }

  List<charts.Series<DailyStats, DateTime>> _createData(List<DailyStats> dailyStats) {
    final greenAccent = Colors.greenAccent;
    final charts.Color recoveredColor = charts.Color(r: greenAccent.red, g: greenAccent.green, b: greenAccent.blue);
    return [
      new charts.Series<DailyStats, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
        domainFn: (DailyStats stats, _) => stats.reportDate,
        measureFn: (DailyStats stats, _) => stats.totalConfirmed,
        data: dailyStats,
      ),
      new charts.Series<DailyStats, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => recoveredColor,
        domainFn: (DailyStats stats, _) => stats.reportDate,
        measureFn: (DailyStats stats, _) => stats.totalRecovered,
        data: dailyStats,
      ),
    ];
  }
}