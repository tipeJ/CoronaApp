import 'package:coronapp/screens/screens.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimelineStatsScreen extends StatelessWidget {
  const TimelineStatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OverviewStatsProvider>(
      builder: (_, provider, child) {
        if (provider.stats != null) return ListView.builder(
          itemCount: provider.stats.dailyStats.length,
          itemBuilder: (_, i) => DailyStatsCard(stats: provider.stats.dailyStats[i]),
        );
        return const SliverToBoxAdapter();
      },
    );
  }
}