import 'package:coronapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CountriesListProvider extends ChangeNotifier {
  final _repository = StatsRepository();

  List<String> _countries;
  String _statsFilterString = "";

  List<String> get countries => _statsFilterString.isEmpty ? _countries : _countries.where((c) => c.toLowerCase().contains(_statsFilterString.toLowerCase())).toList();

  Future<void> refreshCountries() async {
    if (_countries == null) _countries = await _repository.fetchCountriesCodes();
    notifyListeners();
  }

  void filterStats(String filter) {
    _statsFilterString = filter;
    notifyListeners();
  }
}

class CountriesListStatsScreen extends StatelessWidget {
  const CountriesListStatsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<CountriesListProvider>(context).countries == null) Provider.of<CountriesListProvider>(context).refreshCountries();
    return Scaffold(
      appBar: AppBar(title: const Text("Countries")),
      body: Consumer<CountriesListProvider>(
        builder: (_, provider, child) {
          if (provider.countries != null) return SafeArea(
            child: CustomScrollView(slivers: <Widget>[
              SliverAppBar(
                floating: true,
                automaticallyImplyLeading: false,
                title: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Filter Countries"
                  ),
                  onChanged: (str) => provider.filterStats(str),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ListTile(
                    title: Text(provider.countries[i]),
                    onTap: () => Navigator.of(context).pushNamed('country', arguments: provider.countries[i]),
                  ),
                  childCount: provider.countries.length
                )
              )
            ])
          );
          return const SizedBox();
        },
      )
    );
  }
}