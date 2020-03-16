import 'package:coronapp/models/models.dart';
import 'package:coronapp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:coronapp/resources/resources.dart';

class NewsListProvider extends ChangeNotifier {
  final NewsRepository _repository = NewsRepository();
  List<NewsPiece> news = [];

  Future<void> refreshNews() async {
    if (news.isNotEmpty) {
      news = const [];
      notifyListeners();
    }
    news = await _repository.fetchAllNews();
    notifyListeners();
  }
  void removeItemAt(int location) {
    news.removeAt(location.clamp(0, news.length));
    notifyListeners();
  }
}

class MainList extends StatelessWidget {
  bool _fetched = false;
  
  MainList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<NewsListProvider>(context).news.isEmpty && !_fetched) {
      _fetched = true;
      Provider.of<NewsListProvider>(context).refreshNews();
    };
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: Consumer<NewsListProvider>(
        builder: (_, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refreshNews,
            child: provider.news.isEmpty
              ? const Center(child: Text("No News Found"))
              : ListView.separated(
                  itemCount: provider.news.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, i) {
                    final item = provider.news[i];
                    return Dismissible(
                      key: Key(item.url),
                      onDismissed: (direction) {
                        // TODO: Implement options (save, share, etc.)
                        provider.removeItemAt(i);
                      },
                      child: NewsItem(item: item)
                    );
                  },
                )
          );
        },
      ),
    );
  }
}

