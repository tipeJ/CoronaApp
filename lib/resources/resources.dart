export 'news_repository.dart';

bool notNull(Object o) => o != null;

extension nonNull on List {

  List nonNulls() {
    return this.where((w) => notNull(w)).toList();
  }
}

extension formattedStringExtension on DateTime {

  /// Returns a nicely formatted string display of the DateTime object
  String formatString() {
    String hourS = hour < 10 ? "0$hour" : hour.toString();
    String minuteS = minute < 10 ? "0$minute" : minute.toString();
    return "$day/$month/$year, $hourS:$minuteS";
  }
}