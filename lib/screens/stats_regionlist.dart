import 'dart:async';
import 'dart:math';

import 'package:coronapp/models/models.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:coronapp/resources/resources.dart';

class RegionListStatsProvider extends ChangeNotifier {
  final _repository = StatsRepository();
  final String countryName;

  RegionListStatsProvider({this.countryName});

  List<RegionStats> _stats;

  List<RegionStats> get stats => _stats;

  Future<void> refreshStats() async {
    if (countryName == null) {
      _stats = await _repository.fetchAllRegionStats();
    } else {
      _stats = await _repository.fetchRegionStats(countryName);
    }
    notifyListeners();
  }
  
}

class RegionlistStatsScreen extends StatelessWidget {
  Completer<GoogleMapController> _controller = Completer();
  PersistentBottomSheetController _regionsListController;

  RegionlistStatsScreen({Key key}) : super(key: key);

  static final CameraPosition _hubeiPos = CameraPosition(
    target: LatLng(30.9756403482891, 112.270692167452),
    zoom: 3.5,
  );

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RegionListStatsProvider>(context).stats == null) Provider.of<RegionListStatsProvider>(context).refreshStats();
    return Scaffold(
      floatingActionButton: Consumer<RegionListStatsProvider>(
        builder: (context, provider, child) => FloatingActionButton.extended(
          label: const Text('Regions List'),
          icon: const Icon(Icons.list),
          onPressed: () async {
            if (provider.stats != null) {
              if (_regionsListController == null) {
                _regionsListController = Scaffold.of(context).showBottomSheet((context) => DraggableScrollableSheet(
                  builder: (context, controller) => _RegionList(stats: provider.stats, onSelected: (rs) => _goToRegion(rs), controller: controller),
                  initialChildSize: .3,
                  maxChildSize: .7,
                  expand: false
                ));
                await _regionsListController.closed;
                _regionsListController = null;
              } else {
                _regionsListController.close();
                _regionsListController = null;
              }
            }
          },
        )
      ),
      appBar: AppBar(
        title: const Text("Regions"),
      ),
      body: Consumer<RegionListStatsProvider>(
        builder: (context, provider, child) {
          if (provider.stats == null) return const Center(child: CircularProgressIndicator());
          return FutureBuilder<List<Circle>>(
            future: compute(_parseCircles, provider.stats),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                return GoogleMap(
                  initialCameraPosition: _hubeiPos,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  circles: Set<Circle>.of(snapshot.data),
                );
              }
              return const Center(child: CircularProgressIndicator());
            }
          );
        },
      )
    );
  }
  Future<void> _goToRegion(RegionStats stats) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(stats.latitude, stats.longitude),
        zoom: 5.0,
      )
    ));
  }
}

List<Circle> _parseCircles(List<RegionStats> stats) {
  final int biggest = stats.first.confirmed;
  final List<Circle> circles = [];
  for (var i = 0; i < stats.length; i++) {
    final stat = stats[i];
    circles.add(Circle(
      circleId: CircleId("${stats[i].countryRegion}$i"),
      fillColor: Colors.redAccent.withOpacity(0.5),
      strokeColor: Colors.redAccent,
      strokeWidth: 2,
      center: LatLng(stat.latitude, stat.longitude),
      radius: max((biggest / 10937.5) * 100 * pow(stat.confirmed, 1.09 / 2), 12500),
      consumeTapEvents: true,
    ));
  }
  return circles;
}

class _RegionList extends StatefulWidget {
  final List<RegionStats> stats;
  final Function(RegionStats) onSelected;
  final ScrollController controller;
  const _RegionList({this.stats, this.onSelected, this.controller, Key key}) : super(key: key);

  @override
  __RegionListState createState() => __RegionListState();
}

class __RegionListState extends State<_RegionList> {

  TextEditingController _filterController;

  @override
  void initState() {
    _filterController = TextEditingController();
    _filterController.addListener((){setState(() {});});
    super.initState();
  }

  @override
  void dispose() { 
    _filterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats.where((s) => _containsFilterString(s)).toList();
    return CustomScrollView(
      controller: widget.controller,
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          automaticallyImplyLeading: false,
          title: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Filter Regions"
            ),
            controller: _filterController,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, i) => RegionStatsCard(
              stats: stats[i],
              onTap: () => widget.onSelected(stats[i]),
            ),
            childCount: stats.length
          )
        )
      ]
    );
  }
  bool _containsFilterString(RegionStats stats) {
    bool contains = stats.provinceState != null ? stats.provinceState.toLowerCase().contains(_filterController.text.toLowerCase()) : false;
    if (contains) return true;
    return stats.countryRegion.toLowerCase().contains(_filterController.text.toLowerCase());
  }
}