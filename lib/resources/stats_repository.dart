import 'dart:convert';

import 'package:coronapp/models/models.dart';
import 'package:coronapp/resources/resources.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

class StatsRepository {
  factory StatsRepository(){
    return _instance;
  }

  StatsRepository._internal();

  static final StatsRepository _instance = StatsRepository._internal();

  Client client = Client();

  Map<String, dynamic> countriesMap;

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

  Future<List<RegionStats>> fetchAllRegionStats() async {
    final response = await client.get(mathApiAllRegionsUrl);
    final stats = await compute(_decodeRegionStats, response.body);
    return stats;
  }

  Future<List<RegionStats>> fetchRegionStats(String countryName) async {
    if (countriesMap == null) await fetchCountriesCodes();
    final response = await client.get(mathApiCountryUrl + countriesMap[countryName] + '/confirmed');
    final stats = await compute(_decodeRegionStats, response.body);
    return stats;
  }

  Future<List<dynamic>> fetchCountriesCodes() async {
    if (countriesMap != null) return countriesMap.keys.toList();
    final file = await rootBundle.loadString("assets/countries.json");
    countriesMap = await compute(_decodeCountriesJson, file);
    return countriesMap.keys.toList();
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

List<RegionStats> _decodeRegionStats(String body) {
  final parsedJson = json.decode(body);
  List<RegionStats> stats = [];
  for (var i = parsedJson.length-1; i >= 0; i--) {
    stats.add(RegionStats.fromJson(parsedJson[i]));
  }
  return stats;
}

Map<String, dynamic> _decodeCountriesJson(String countriesJson) {
  final parsedJson = json.decode(countriesJson);
  return parsedJson['countries'];
}