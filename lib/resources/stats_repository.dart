import 'dart:convert';

import 'package:coronapp/models/models.dart';
import 'package:coronapp/resources/resources.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class StatsRepository {
  factory StatsRepository(){
    return _instance;
  }

  StatsRepository._internal();

  static final StatsRepository _instance = StatsRepository._internal();

  Client client = Client();

  /// Function for fetching news content from all RSS Sources
  Future<VirusStats> fetchVirusStats() async {
    final overviewResponse = await client.get(mathApiOverviewUrl);
    final overviewStats = await compute(_decodeOverviewStats, overviewResponse.body);

    final dailyResponse = await client.get(mathApiDailyStatsUrl);
    final dailyStats = await compute(_decodeDailyStats, dailyResponse.body);

    return VirusStats(
      overviewStats: overviewStats,
      dailyStats: dailyStats
    );
  }
}

OverviewStats _decodeOverviewStats(String body) {
  final parsedJson = json.decode(body);
  return OverviewStats.fromJson(parsedJson);
}

List<DailyStats> _decodeDailyStats(String body) {
  final parsedJson = json.decode(body);
  List<DailyStats> stats = [];
  for (var i = parsedJson.length-1; i >= 0; i--) {
    stats.add(DailyStats.fromJson(parsedJson[i]));
  }
  return stats;
}