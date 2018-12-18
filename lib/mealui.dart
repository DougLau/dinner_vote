import 'package:flutter/material.dart';
import 'meal.dart';
import 'db.dart';

class MealScreen extends StatefulWidget {
  final Meal meal;
  MealScreen(this.meal);

  @override
  State<StatefulWidget> createState() => new _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
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
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle())),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          Padding(padding: new EdgeInsets.all(4.0)),
          TextField(
            controller: _description,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          Padding(padding: new EdgeInsets.all(4.0)),
          _buildButton(context),
        ],
      ),
    );
  }

  String _screenTitle() {
    return (widget.meal.id != null) ? 'Edit Meal' : 'Add Meal';
  }

  String _buttonTitle() {
    return (widget.meal.id != null) ? 'Update' : 'Add';
  }

  Widget _buildButton(BuildContext context) {
    return RaisedButton(
      child: Text(_buttonTitle()),
      onPressed: () {
        if (widget.meal.id != null) {
          db
              .updateMeal(Meal.fromMap({
            'id': widget.meal.id,
            'title': _title.text,
            'description': _description.text,
            'on_menu': widget.meal.on_menu,
          }))
              .then((_) {
            Navigator.pop(context, 'update');
          });
        } else {
          db.saveMeal(Meal(_title.text, _description.text)).then((_) {
            Navigator.pop(context, 'save');
          });
        }
      },
    );
  }
}
