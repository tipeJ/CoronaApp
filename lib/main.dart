import 'package:coronapp/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoronaApp',
      theme: ThemeData(
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
}

class _BottomAppBarWrapper extends StatefulWidget {
  _BottomAppBarWrapper({Key key}) : super(key: key);

  @override
  _BottomAppBarWrapperState createState() => _BottomAppBarWrapperState();
}

class _BottomAppBarWrapperState extends State<_BottomAppBarWrapper> {
  int _currentPage = 1;

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
            title: Text("Status")
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text("Settings")
          )
        ],
        onTap: (i) {
          setState(() {
            _currentPage = i;
          });
        },
      ),
      body: _getPage()
    );
  }

  Widget _getPage() {
    if (_currentPage == 0) {
      return ChangeNotifierProvider(
        create: (_) => NewsListProvider(),
        child: MainList(),
      );
    } else if (_currentPage == 1) {
      return StatusScreen();
    } else {
      return Scaffold();
    }
  }
}