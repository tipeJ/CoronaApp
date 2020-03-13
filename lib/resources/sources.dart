import 'package:coronapp/models/models.dart';

const Map<String, NewsSource> sources = {
  "NYPost" : NewsSource(
    rssUrl: "https://nypost.com/coronavirus/feed/",
  ),
  "NYTimes" : NewsSource(
    rssUrl: "https://rss.nytimes.com/services/xml/rss/nyt/Health.xml",
    keyword: "Coronavirus (2019-nCoV)",
  ),
  "Politico (EU)" : NewsSource(
    rssUrl: "https://www.politico.eu/tag/coronavirus/feed/",
  ),
};