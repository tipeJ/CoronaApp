import 'package:coronapp/screens/screens.dart';
import 'package:coronapp/screens/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coronapp/resources/resources.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
} 

class SettingsProvider extends ChangeNotifier {
  SharedPreferences preferences;

  void preferencesChanged() async {
    preferences = await SharedPreferences.getInstance();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SettingsProvider(),
      child: _CoronaApp(),
    );
  }
}

class _CoronaApp extends StatelessWidget {
  const _CoronaApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (_, provider, child) {
        if (provider.preferences != null) {
          bool darkMode = provider.preferences.getBool(prefs_darkmode) ?? false;
          return MaterialApp(
            title: 'CoronaApp',
            theme: ThemeData(
              brightness: darkMode ? Brightness.dark : Brightness.light,
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
            ),
            home: _BottomAppBarWrapper()
          );
        }
        provider.preferencesChanged();
        return Material(child: const Center(child: CircularProgressIndicator()));
      }
    );
  }
}

class _BottomAppBarWrapper extends StatefulWidget {
  _BottomAppBarWrapper({Key key}) : super(key: key);

  @override
  _BottomAppBarWrapperState createState() => _BottomAppBarWrapperState();
}

class _BottomAppBarWrapperState extends State<_BottomAppBarWrapper> {
  int _currentPage = 1;

  final _statsScreen = GlobalKey<NavigatorState>();

  Future<bool> _didPopRoute() {
    if (_currentPage == 1) {
      return _statsScreen.currentState.maybePop();
    }
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_chart),
            title: Text("News")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.multiline_chart),
            title: Text("Stats")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings")
          )
        ],
        onTap: (i) {
          if (i == _currentPage && i == 1) {
            _statsScreen.currentState.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentPage = i;
            });
          }
        },
      ),
      body: WillPopScope(
        onWillPop: () async => !await _didPopRoute(),
        child: IndexedStack(
          index: _currentPage,
          children: [
            ChangeNotifierProvider(
              create: (_) => NewsListProvider(),
              child: MainList(),
            ),
            ChangeNotifierProvider(
              create: (_) => OverviewStatsProvider(),
              child: Navigator(
                key: _statsScreen,
                initialRoute: '/',
                onGenerateRoute: (settings) => StatsRouter.generateRoute(settings.name, settings.arguments),
              )
            ),
            SettingsScreen()
          ],
        )
      )
    );
  }
}