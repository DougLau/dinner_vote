import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(DinnerVoteApp());

class DinnerVoteApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'Dinner Vote';
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DinnerListPage(title: title),
    );
  }
}

class DinnerListPage extends StatefulWidget {
  DinnerListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DinnerListPageState createState() => _DinnerListPageState();
}

class _DinnerListPageState extends State<DinnerListPage> {
  final _dinners = <String>['Turkey Soup', 'Taco Noodles'];
  final _biggerFont = const TextStyle(fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: _dinners.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return _buildRow(_dinners[index]);
        });
  }

  Widget _buildRow(String dinner) {
    return ListTile(
      title: Text(
        dinner,
        style: _biggerFont,
      ),
    );
  }
}
