class VirusStats {
  final OverviewStats overviewStats;
  final List<DailyStats> dailyStats;

  const VirusStats({
    this.overviewStats,
    this.dailyStats
  });
}

class OverviewStats {
  final int totalConfirmed;
  final int totalRecovered;
  final int totalDeaths;
  final String lastUpdate;

  const OverviewStats({
    this.totalConfirmed,
    this.totalRecovered,
    this.totalDeaths,
    this.lastUpdate,
  });

  static OverviewStats fromJson(dynamic json) => OverviewStats(
    totalConfirmed : json['confirmed']['value'],
    totalRecovered : json['recovered']['value'],
    totalDeaths : json['deaths']['value'],
    lastUpdate : json['lastUpdate'],
  );
}

class DailyStats {
  final DateTime reportDate;
  final int mainlandChina;
  final int otherLocations;
  final int totalConfirmed;
  final int totalRecovered;
  final int deltaConfirmed;
  final int deltaRecovered;
  final int objectId;

  const DailyStats({
    this.reportDate,
    this.mainlandChina,
    this.otherLocations,
    this.totalConfirmed,
    this.totalRecovered,
    this.deltaConfirmed,
    this.deltaRecovered,
    this.objectId,
  });

  static DailyStats fromJson(dynamic json,) => DailyStats(
    reportDate : DateTime.fromMillisecondsSinceEpoch(json['reportDate']),
    mainlandChina : json['mainlandChina'],
    otherLocations : json['otherLocations'],
    totalConfirmed : json['totalConfirmed'],
    totalRecovered : json['totalRecovered'],
    deltaConfirmed : json['deltaConfirmed'],
    deltaRecovered : json['deltaRecovered'],
    objectId : json['objectid'],
  );
}