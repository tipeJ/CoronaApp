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
          )
        ]),
      )
    );
  }
}