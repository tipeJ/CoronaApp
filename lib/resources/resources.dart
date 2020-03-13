export 'sources.dart';
export 'news_repository.dart';

bool notNull(Object o) => o != null;

extension nonNull on List {

  List nonNulls() {
    return this.where((w) => notNull(w)).toList();
  }
}