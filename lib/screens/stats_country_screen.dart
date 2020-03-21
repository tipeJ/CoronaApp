import 'package:CoronaApp/models/models.dart';
import 'package:CoronaApp/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CoronaApp/resources/resources.dart';

class CountryStatsProvider extends ChangeNotifier {
  final _repository = StatsRepository();

  final String countryName;

  CountryStatsProvider({this.countryName});

  List<RegionStats> _stats;

  List<RegionStats> get stats => _stats;

  Future<void> refreshStats() async {
    _stats = await _repository.fetchRegionStats(countryName);
    notifyListeners();
  }
  
}

class CountryStatsScreen extends StatelessWidget {
  CountryStatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<CountryStatsProvider>(context).stats == null) Provider.of<CountryStatsProvider>(context).refreshStats();
    return Scaffold(
      appBar: AppBar(
        title: Text(Provider.of<CountryStatsProvider>(context).countryName),
      ),
      body: Consumer<CountryStatsProvider>(
        builder: (context, provider, child) {
          if (provider.stats == null) return const Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: provider.stats.length,
            itemBuilder: (_, i) {
              return RegionStatsCard(
                stats: provider.stats[i],
              );
            },
          );
        },
      )
    );
  }
}