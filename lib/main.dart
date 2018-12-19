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
        primaryColor: Color(0xFF3832AC),
        primaryColorLight: Color(0xFF705DDF),
        primaryColorDark: Color(0xFF000A7C),
        accentColor: Color(0xFFFFA866),
        cardColor: Color(0xFFDDDDDD),
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
        itemCount: _dinners.length,
        itemBuilder: (context, i) {
          return _buildRow(_dinners[i]);
        });
  }

  Widget _buildRow(Meal dinner) {
    return ListTile(
      title: Text(
        dinner.title,
        style: Theme.of(context).textTheme.title,
      ),
      subtitle: Text(dinner.description),
      onTap: () => _editMeal(context, dinner),
    );
  }

  _createMeal(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealPage(Meal("", ""))),
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

  _editMeal(BuildContext context, Meal dinner) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MealPage(dinner)),
    );
    if (result == 'update' || result == 'delete') {
      _loadMeals();
    }
  }
}
