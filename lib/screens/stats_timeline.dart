import 'package:coronapp/screens/screens.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:coronapp/resources/resources.dart';

class TimelineStatsScreen extends StatelessWidget {
  const TimelineStatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline")),
      body: Consumer<OverviewStatsProvider>(
        builder: (_, provider, child) {
          if (provider.stats != null) return SafeArea(
            child: ListView.separated(
              itemCount: provider.stats.dailyStats.length,
              separatorBuilder: (_, __) => const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider()
              ),
              itemBuilder: (_, i) => StickyHeader(
                header: Container(
                  height: 35.0,
                  alignment: Alignment.centerLeft,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).canvasColor,
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(provider.stats.dailyStats[i].reportDate.formatString(includeTime: false)),
                ),
                content: DailyStatsCard(stats: provider.stats.dailyStats[i])
              ),
            )
          );
          return const SliverToBoxAdapter();
        },
      )
    );
  }
}