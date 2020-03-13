import 'package:coronapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'resources/resources.dart';

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
}

class MainList extends StatelessWidget {
  const MainList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Provider.of<NewsListProvider>(context).news.isEmpty) Provider.of<NewsListProvider>(context).refreshNews();
    return Scaffold(
      appBar: AppBar(
        title: const Text("News"),
      ),
      body: Container(
        child: Consumer<NewsListProvider>(
          builder: (_, provider, child) {
            return RefreshIndicator(
              onRefresh: provider.refreshNews,
              child: ListView.separated(
                itemCount: provider.news.length,
                separatorBuilder: (_, i) => const Divider(height: 0.0),
                itemBuilder: (_, i) {
                  final item = provider.news[i];
                  return InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(item.title, style: Theme.of(context).textTheme.headline6),
                          Text(item.description, style: Theme.of(context).textTheme.bodyText2),
                          Wrap(
                            children: <Widget>[
                              Text(item.source),
                              item.published != null ? Text(item.published.toString()) : null,
                            ].nonNulls(),
                          )
                        ]
                      )
                    ),
                    onTap: () {},
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}