import 'package:flutter/material.dart';
import 'db.dart';
import 'meal.dart';
import 'mealui.dart';

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
  final _biggerFont = const TextStyle(fontSize: 20.0);
  final _dinners = new List<Meal>();
  final _db = DbHelper();

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createMeal(context),
      ),
    );
  }

  Widget _buildBody() {
    return ListView.builder(
        padding: const EdgeInsets.all(6.0),
        itemCount: _dinners.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;
          return _buildRow(_dinners[index]);
        });
  }

  Widget _buildRow(Meal dinner) {
    return ListTile(
      title: Text(
        dinner.title,
        style: _biggerFont,
      ),
    );
  }

  _createMeal(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealScreen(Meal("", ""))),
    );
    if (result == 'save') {
      _loadMeals();
    }
  }

  _loadMeals() async {
    _db.getAllMeals().then((meals) {
      setState(() {
        _dinners.clear();
        meals.forEach((meal) {
          _dinners.add(Meal.fromMap(meal));
        });
      });
    });
  }
}
