import 'package:coronapp/models/models.dart';
import 'package:coronapp/resources/resources.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:webfeed/domain/rss_feed.dart';

class NewsRepository {
  factory NewsRepository(){
    return _instance;
  }

  NewsRepository._internal();

  static final NewsRepository _instance = NewsRepository._internal();

  Client client = Client();

  /// Function for fetching news content from all RSS Sources
  Future<List<NewsPiece>> fetchAllNews() async {
    List<NewsPiece> items = [];
    for (var i = 0; i < sources.length; i++) {
      final response = await client.get(sources.values.elementAt(i).rssUrl);
      final keyword = sources.values.elementAt(i).keyword;

      items.addAll(await compute(_parseAndFilterRssItems, {
        'rssBody' : response.body,
        'keyword' : keyword,
        'source' : sources.keys.elementAt(i)
      }));
    }
    return items..sort((a, b) => b.published.compareTo(a.published));
  }
}

List<NewsPiece> _parseAndFilterRssItems(Map<String, String> variables) {
  final List<NewsPiece> items = [];

  final body = variables['rssBody'];
  final keyword = variables['keyword'];
  final source = variables['source'];

  final feed = RssFeed.parse(body);
  for (var i = 0; i < feed.items.length; i++) {
    final rssItem = feed.items[i];
    bool isRelevant = true;
    if (keyword != null) {
      final Iterable<String> categories = rssItem.categories.map<String>((category) => category.value);
      isRelevant = categories.contains(keyword);
    }
    if (isRelevant) items.add(NewsPiece(
      source: source,
      url: rssItem.link,
      title: rssItem.title,
      description: rssItem.description,
      published: rssItem.pubDate != null ? _parseDateTimeFromRss(rssItem.pubDate) : null,
    ));
  }
  return items;
}

DateTime _parseDateTimeFromRss(String pubDate) {
  final splits = pubDate.split(' ');
  final String day = splits[1];
  final int monthIndex = _months.indexOf(splits[2]);
  final String month = monthIndex > 9 ? monthIndex.toString() : '0$monthIndex';
  final String year = splits[3];
  final time = splits[4].split(':');
  final String hour = time[0];
  final String minute = time[1];
  final String timeZone = splits[5].replaceRange(3, 3, ':');

  final date = DateTime.parse('$year-$month-${day}T$hour:$minute:00$timeZone');
  return date;
}

const Map<int, String> _locations = {
  -11: 'America/Unalaska',
  -10: 'America/Fairbanks',
  -9: 'Unalaska',
  -8: 'Unalaska',
  -7: 'Unalaska',
  -6: 'Unalaska',
  -5: 'Unalaska',
  -4: 'Unalaska',
  -3: 'Unalaska',
  -2: 'Unalaska',
  -1: 'Reykjavik',
  0: 'London',
  1: 'Unalaska',
  2: 'Unalaska',
  3: 'Unalaska',
  4: 'Unalaska',
  5: 'Unalaska',
  6: 'Unalaska',
  7: 'Unalaska',
  8: 'Unalaska',
  9: 'Unalaska',
  10: 'Unalaska',
  11: 'Unalaska',
  12: 'Unalaska',
};

/// List of months for rss DateTime parsing
const List<String> _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];
