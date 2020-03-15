import 'dart:convert';

import 'package:coronapp/models/models.dart';
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
    final response = await client.get('http://10.0.2.2:8080/news');
    items = await compute(_decodeNewsJsonResponse, response.body);
    return items;
  }
}

List<NewsPiece> _decodeNewsJsonResponse(String response) {
  List<NewsPiece> items = [];
  final j = json.decode(response);
  print(j.length);
  for (var i = 0; i < j.length; i++) {
    final n = j[i];
    final published = _parseNewsJsonDate(n['pubDate']);
    items.add(NewsPiece(
      source: n['source'],
      title: n['title'],
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