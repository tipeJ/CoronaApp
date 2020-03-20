import 'dart:convert';

import 'package:CoronaApp/models/models.dart';
import 'package:CoronaApp/resources/resources.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

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
    final response = await client.get(news_api_url);
    items = await compute(_decodeNewsJsonResponse, response.body);
    return items;
  }
}

List<NewsPiece> _decodeNewsJsonResponse(String response) {
  List<NewsPiece> items = [];
  final j = json.decode(response);
  for (var i = 0; i < j.length; i++) {
    final n = j[i];
    final published = _parseNewsJsonDate(n['pubDate']);
    items.add(NewsPiece(
      source: n['source'],
      title: n['title'].replaceAll('&apos;', '"'),
      description: n['description'],
      url: n['url'],
      thumbnailUrl: n['thumbnailurl'],
      published: published
    ));
  }
  return items;
}

DateTime _parseNewsJsonDate(String pubDate) {
  final splits = pubDate.split('-');
  final int year = int.parse(splits[0]);
  final int month = int.parse(splits[1]);
  final dayAndTime = splits[2].split('T');
  final int day = int.parse(dayAndTime.first);
  final time = dayAndTime.last.substring(0, dayAndTime.last.length-1).split(':');
  final int hour = int.parse(time[0]);
  final int minute = int.parse(time[1]);
  return DateTime.utc(year, month, day, hour, minute);
}