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
    return items;
  }
}

List<NewsPiece> _parseAndFilterRssItems(Map<String, String> variables) {
    final List<NewsPiece> items = [];

    final body = variables['rssBody'];
    final keyword = variables['keyword'];
    final source = variables['source'];

    final feed = RssFeed.parse(body);
    feed.items.forEach((rssItem){
      bool isRelevant = true;
      rssItem.pubDatel
      if (keyword != null) {
        final Iterable<String> categories = rssItem.categories.map<String>((category) => category.value);
        isRelevant = categories.contains(keyword);
      }
      print(rssItem.pubDate ?? "nulled");
      if (isRelevant) items.add(NewsPiece(
        source: source,
        url: rssItem.link,
        title: rssItem.title,
        description: rssItem.description,
        published: rssItem.pubDate != null ? DateTime.now() : null,
      ));
    });
    return items;
  }