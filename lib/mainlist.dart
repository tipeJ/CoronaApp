import 'package:coronapp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
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
  void removeItemAt(int location) {
    news.removeAt(location.clamp(0, news.length));
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
                  return Dismissible(
                    key: Key(item.url),
                    onDismissed: (direction) {
                      // TODO: Implement options (save, share, etc.)
                      provider.removeItemAt(i);
                    },
                    child: _NewsItem(item: item)
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

class _NewsItem extends StatelessWidget {
  const _NewsItem({
    Key key,
    @required this.item,
  }) : super(key: key);

  final NewsPiece item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(item.title, style: Theme.of(context).textTheme.subhead),
            const SizedBox(height: 2.5),
            Text(
              item.description, 
              style: Theme.of(context).textTheme.body1.apply(color: Colors.grey[700]),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.overline,
                children: <InlineSpan>[
                  TextSpan(text: "${item.source} - "),
                  item.published != null ? TextSpan(
                    text: item.published.formatString()
                  ) : null,
                ].nonNulls(),
              )
            )
          ]
        )
      ),
      onTap: () async {
        final url = item.url;
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          throw "Couldn't launch $url";
        }
      },
    );
  }
}