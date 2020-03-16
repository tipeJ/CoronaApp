import 'package:coronapp/main.dart';
import 'package:coronapp/resources/resources.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Consumer<SettingsProvider>(
        builder: (_, provider, child) => ListView(children: <Widget>[
          ListTile(
            title: const Text("Dark Mode"),
            subtitle: const Text("Enables dark theme for this application"),
            trailing: Switch(
              value: provider.preferences.get(prefs_darkmode) ?? false,
              onChanged: (newValue) {
                provider.preferences.setBool(prefs_darkmode, newValue);
                provider.preferencesChanged();
              },
            ),
          ),
          ListTile(
            title: const Text("Home Country"),
            subtitle: Text(provider.preferences.getString(prefs_home_region) ?? "None"),
            onTap: () async {
              final country = await showDialog<String>(
                context: context,
                builder: (_) => _SettingsSetHomeCountry()
              );
              if (country != null) {
                if (country.isEmpty) {
                  // Remove entry if set on 'None'
                  provider.preferences.remove(prefs_home_region);
                  provider.preferencesChanged();
                } else {
                  provider.preferences.setString(prefs_home_region, country);
                  provider.preferencesChanged();
                }
              }
            },
          ),
          ListTile(
            title: const Text("Show Home Infographic"),
            subtitle: const Text("Shows an infographic image in the stats menu. Requires Home Country"),
            trailing: Switch(
              value: provider.preferences.get(prefs_show_home_infographic) ?? false,
              onChanged: (newValue) {
                provider.preferences.setBool(prefs_show_home_infographic, newValue);
                provider.preferencesChanged();
              },
            ),
          ),
          ListTile(
            title: const Text("App Information"),
            onTap: () => showDialog(
              context: context,
              child: AlertDialog(
                title: const Text(app_version),
                content: const SizedBox(),
              )
            ),
          ),
        ]),
      )
    );
  }
}

class _SettingsSetHomeCountry extends StatefulWidget {
  const _SettingsSetHomeCountry({Key key}) : super(key: key);

  @override
  __SettingsSetHomeCountryState createState() => __SettingsSetHomeCountryState();
}

class __SettingsSetHomeCountryState extends State<_SettingsSetHomeCountry> {
  Future<List<dynamic>> _countriesFuture;

  @override
  void initState() {
    _countriesFuture = StatsRepository().fetchCountriesCodes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).canvasColor,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        child: FutureBuilder<List<dynamic>>(
          future: _countriesFuture,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (_, i) => ListTile(
                title: Text(i == 0 ? "None" : snapshot.data[i-1]),
                onTap: () {
                  Navigator.of(context).pop(i == 0 ? "" : snapshot.data[i-1]);
                },
              ),
            );
            return const Center(child: CircularProgressIndicator());
          },
        )
      )
    );
  }
}