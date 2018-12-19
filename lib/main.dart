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
      home: MealListPage(title: title),
    );
  }
}
