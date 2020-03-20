import 'package:connectivity/connectivity.dart';
import 'package:CoronaApp/models/models.dart';
import 'package:CoronaApp/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:CoronaApp/resources/resources.dart';

class NewsListProvider extends ChangeNotifier {
  final NewsRepository _repository = NewsRepository();
  String error;
  List<NewsPiece> news = [];

  Future<void> refreshNews() async {
    final connectivity = await (Connectivity().checkConnectivity());
    if (connectivity == ConnectivityResult.none) {
      error = error_nointernet;
      notifyListeners();
      return;
    }
    if (news.isNotEmpty) {
      news = const [];
      notifyListeners();
    }
    news = await _repository.fetchAllNews();
    error = null; 
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<NewsListProvider>(context, listen: false).refreshNews();
            },
          )
        ],
      ),
      body: Consumer<NewsListProvider>(
        builder: (_, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refreshNews,
            child: provider.error != null
              ? Center(child: Text(provider.error))
              : provider.news.isNotEmpty
                ? ListView.separated(
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
                : const Center(child: Text("No News Found"))
          );
        },
      ),
    );
  }
}

