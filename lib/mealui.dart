import 'package:flutter/material.dart';
import 'meal.dart';
import 'db.dart';

class MealListPage extends StatefulWidget {
  MealListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MealListPageState createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
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

class MealPage extends StatefulWidget {
  final Meal meal;
  MealPage(this.meal);

  @override
  State<StatefulWidget> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle())),
      body: MealBody(widget.meal),
    );
  }

  String _screenTitle() {
    return (widget.meal.id != null) ? 'Edit Meal' : 'Add Meal';
  }
}

class MealBody extends StatefulWidget {
  // This needs to be separate from MealPage to allow
  // SnackBars to work with the Scaffold in MealPage
  final Meal meal;
  MealBody(this.meal);

  @override
  State<StatefulWidget> createState() => _MealBodyState();
}

class _MealBodyState extends State<MealBody> {
  DbHelper db = new DbHelper();

  TextEditingController _title;
  TextEditingController _description;

  @override
  initState() {
    super.initState();

    _title = new TextEditingController(text: widget.meal.title);
    _description = new TextEditingController(text: widget.meal.description);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(6.0),
      children: <Widget>[
        TextField(
          controller: _title,
          decoration: InputDecoration(labelText: 'Title', isDense: true),
          maxLength: 22,
        ),
        Padding(padding: new EdgeInsets.all(2.0)),
        TextField(
          controller: _description,
          decoration: InputDecoration(labelText: 'Description', isDense: true),
          maxLength: 22,
        ),
        Padding(padding: new EdgeInsets.all(2.0)),
        _buildChips(widget.meal),
        _buildButtons(context),
      ],
    );
  }

  Widget _buildChips(Meal meal) {
    return Wrap(
      spacing: 6.0,
      runSpacing: 4.0,
      children: <Widget>[
        _buildChip(meal, 'Beef'),
        _buildChip(meal, 'Chicken'),
        _buildChip(meal, 'Mexican'),
      ],
    );
  }

  Widget _buildChip(Meal meal, String lbl) {
    return FilterChip(
      selectedColor: Theme.of(context).accentColor,
      selected: meal.hasTag(lbl),
      label: Text(lbl),
      onSelected: (bool value) {
        setState(() {
          // FIXME: set tag on meal
          return value;
        });
      },
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (widget.meal.id != null) {
      return Row(
        children: <Widget>[
          Expanded(child: _buildDeleteButton(context)),
          Expanded(child: _buildButton(context)),
        ],
      );
    } else {
      return _buildButton(context);
    }
  }

  Widget _buildDeleteButton(BuildContext context) {
    return FlatButton.icon(
      label: Text('Delete'),
      icon: Icon(Icons.delete),
      textColor: Theme.of(context).primaryColorDark,
      onPressed: () {
        _deleteMeal(context);
      },
    );
  }

  _deleteMeal(BuildContext context) {
    db.deleteMeal(widget.meal.id).then((_) {
      Navigator.pop(context, 'delete');
    });
  }

  String _buttonTitle() {
    return (widget.meal.id != null) ? 'Update' : 'Add';
  }

  IconData _buttonIcon() {
    return (widget.meal.id != null) ? Icons.done : Icons.add_circle;
  }

  Widget _buildButton(BuildContext context) {
    return FlatButton.icon(
      label: Text(_buttonTitle()),
      icon: Icon(_buttonIcon()),
      textColor: Theme.of(context).primaryColorDark,
      onPressed: () {
        if (widget.meal.id != null) {
          _updateMeal(context);
        } else {
          _saveMeal(context);
        }
      },
    );
  }

  String _getTitle() {
    return _title.text.trim();
  }

  String _getDescription() {
    return _description.text.trim();
  }

  _updateMeal(BuildContext context) {
    db
        .updateMeal(Meal.fromMap({
      'id': widget.meal.id,
      'title': _getTitle(),
      'description': _getDescription(),
    }))
        .then((_) {
      Navigator.pop(context, 'update');
    }).catchError((e) {
      final snackBar = SnackBar(content: Text('Title must be unique'));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  _saveMeal(BuildContext context) {
    final title = _getTitle();
    if (title == 0)
      return;
    db.saveMeal(Meal(title, _getDescription())).then((_) {
      Navigator.pop(context, 'save');
    }).catchError((e) {
      final snackBar = SnackBar(content: Text('Title must be unique'));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
