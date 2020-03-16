import 'package:coronapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatsRouter {
  static Route<dynamic> generateRoute(String route, dynamic args, [String key]) {
    return MaterialPageRoute(builder: (con) => _getChild(con, route, args));
  }
  static Widget _getChild(BuildContext context, String route, dynamic args) {
    Widget child;
    switch (route) {
      case '/':
        child = StatusScreen();
        break;
      case 'timeline':
        child = TimelineStatsScreen();
        break;
      case 'allregions':
        child = ChangeNotifierProvider(
          create: (_) => RegionListStatsProvider(),
          child: RegionlistStatsScreen(),
        );
        break;
      default:
        child = Scaffold(
          body: Center(
            child: Text('No route defined for $route'),
          ),
        );
    }
    return child;
  }
}