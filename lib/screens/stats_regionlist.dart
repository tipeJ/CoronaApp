import 'package:coronapp/models/models.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:coronapp/resources/resources.dart';

class RegionListStatsProvider extends ChangeNotifier {
  final _repository = StatsRepository();
  List<RegionStats> stats;

  Future<void> refreshStats() async {
    stats = await _repository.fetchAllRegionStats();
    notifyListeners();
  }
}

class RegionlistStatsScreen extends StatelessWidget {
  const RegionlistStatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RegionListStatsProvider>(context).stats == null) Provider.of<RegionListStatsProvider>(context).refreshStats();
    return Scaffold(
      appBar: AppBar(title: const Text("Timeline")),
      body: Consumer<RegionListStatsProvider>(
        builder: (_, provider, child) {
          if (provider.stats != null && provider.stats.isNotEmpty) return SafeArea(
            child: ListView.builder(
              itemCount: provider.stats.length,
              itemBuilder: (_, i) => RegionStatsCard(stats: provider.stats[i]),
            )
          );
          if (provider.stats == null) return const SizedBox();
          return const Center(child: CircularProgressIndicator());
        },
      )
    );
  }
}