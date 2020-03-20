import 'package:CoronaApp/models/models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:CoronaApp/resources/resources.dart';

class NewsItem extends StatelessWidget {
  const NewsItem({
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
              style: Theme.of(context).textTheme.body1.apply(color: Theme.of(context).textTheme.body1.color.withOpacity(0.7)),
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