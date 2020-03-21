import 'package:connectivity/connectivity.dart';
import 'package:CoronaApp/models/models.dart';
import 'package:CoronaApp/resources/resources.dart';
import 'package:CoronaApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'package:provider/provider.dart';

class OverviewStatsProvider extends ChangeNotifier {
  final _repository = StatsRepository();
  String error;
  VirusStats stats;
  Future<void> refreshStatus() async {
    final connectivity = await (Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.none) {
      error = error_nointernet;
      notifyListeners();
      return Future.value();
    }
    stats = await _repository.fetchVirusStats();
    error = null;
    notifyListeners();
    return Future.value();
  }
}

class StatusScreen extends StatelessWidget {
  static const _statsAdkey = "ca-app-pub-4126957694857478/4427716789";
  StatusScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<OverviewStatsProvider>(context).stats == null) Provider.of<OverviewStatsProvider>(context, listen: false).refreshStatus();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stats"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => Provider.of<OverviewStatsProvider>(context, listen: false).refreshStatus(),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => Provider.of<OverviewStatsProvider>(context, listen: false).refreshStatus(),
        child: Provider.of<OverviewStatsProvider>(context, listen: false).error == null
          ? ListView(children: <Widget>[
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
                          "World Map",
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      )
                    )
                  )
                ),
              ]),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250.0,
                child: NativeAdmob(
                  adUnitID: _statsAdkey,
                  options: const NativeAdmobOptions(
                    showMediaContent: true,
                    headlineTextStyle: NativeTextStyle(color: Colors.green)
                  ),
                  loading: const SizedBox(),
                ),
              ),
              HomeStatImageCard()
          ])
        : Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(child: Text(Provider.of<OverviewStatsProvider>(context, listen: false).error))
          )
      )
    );
  }
}
