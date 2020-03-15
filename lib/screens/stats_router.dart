import 'package:coronapp/screens/screens.dart';
import 'package:flutter/material.dart';

class StatsRouter {
  static Route<dynamic> generateRoute(String route, dynamic args, [String key]) {
    switch (route) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => StatusScreen()
        );
      case 'timeline':
        return MaterialPageRoute(
          builder: (_) => TimelineStatsScreen()
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for $route'),
            ),
          )
        );
    }
  }
}