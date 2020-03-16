import 'package:coronapp/models/models.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coronapp/resources/resources.dart';

class RegionListStatsProvider extends ChangeNotifier {
  final _repository = StatsRepository();
  final String countryName;

  RegionListStatsProvider({this.countryName});

  List<RegionStats> _stats;
  String _statsFilterString = "";

  List<RegionStats> get stats => _stats == null || _statsFilterString.isEmpty ? _stats : _stats.where((s) => _containsFilterString(s)).toList();

  Future<void> refreshStats() async {
    if (countryName == null) {
      _stats = await _repository.fetchAllRegionStats();
    } else {
      _stats = await _repository.fetchRegionStats(countryName);
    }
    notifyListeners();
  }

  void filterStats(String filter) {
    _statsFilterString = filter;
    notifyListeners();
  }

  bool _containsFilterString(RegionStats stats) {
    bool contains = stats.provinceState != null ? stats.provinceState.toLowerCase().contains(_statsFilterString.toLowerCase()) : false;
    if (contains) return true;
    return stats.countryRegion.toLowerCase().contains(_statsFilterString.toLowerCase());
  }
}

class RegionlistStatsScreen extends StatelessWidget {
  const RegionlistStatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RegionListStatsProvider>(context).stats == null) Provider.of<RegionListStatsProvider>(context).refreshStats();
    return Scaffold(
      appBar: AppBar(title: const Text("Regions")),
      body: Consumer<RegionListStatsProvider>(
        builder: (_, provider, child) {
          if (provider.stats != null) return SafeArea(
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                title: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Filter Regions"
                  ),
                  onChanged: (str) => provider.filterStats(str),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => RegionStatsCard(stats: provider.stats[i]),
                  childCount: provider.stats.length
                )
              )
            ])
          );
          if (provider.stats == null) return const SizedBox();
        },
      )
    );
  }
}