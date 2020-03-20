import 'package:CoronaApp/main.dart';
import 'package:CoronaApp/resources/resources.dart';
import 'package:CoronaApp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeStatImageCard extends StatelessWidget {
  const HomeStatImageCard({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (_, settingsP, child) => Consumer<OverviewStatsProvider>(
        builder: (_, provider, child) => provider.stats != null && provider.stats.homeCountryImageUrl != null && (settingsP.preferences.getBool(prefs_show_home_infographic) ?? false)
          ? Container(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(provider.stats.homeCountryImageUrl)
            )
          : const SizedBox()
      )
    );
  }
}