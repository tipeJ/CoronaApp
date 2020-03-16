import 'package:coronapp/models/models.dart';
import 'package:coronapp/resources/resources.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OverviewStatsProvider extends ChangeNotifier {
  final _repository = StatsRepository();
  VirusStats stats;

  Future<void> refreshStatus() async {
    stats = await _repository.fetchVirusStats();
    notifyListeners();
    return Future.value();
  }
}

class StatusScreen extends StatelessWidget {
  const StatusScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<OverviewStatsProvider>(context).stats == null) Provider.of<OverviewStatsProvider>(context, listen: false).refreshStatus();
    return Scaffold(
      appBar: AppBar(title: const Text("Stats")),
      body: RefreshIndicator(
        onRefresh: () async => Provider.of<OverviewStatsProvider>(context, listen: false).refreshStatus(),
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(5.0),
              sliver: SliverList(delegate: SliverChildListDelegate([
                DailyStatCard(),
                StatsOverviewCountCard(),
                OverAllStatsChart(),
                Row(children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed('timeline'),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Timeline",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        )
                      )
                    )
                  ),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed('allcountries'),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Countries",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        )
                      )
                    )
                  ),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () => Navigator.of(context).pushNamed('allregions'),
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "Regions",
                            style: Theme.of(context).textTheme.subhead,
                          ),
                        )
                      )
                    )
                  )
                ])
              ]))
            ),
            
          ],
        )
      )
    );
  }
}