import 'package:flutter/material.dart';
import 'mealui.dart';
import 'person_ui.dart';

void main() => runApp(DinnerVoteApp());

final key = GlobalKey<DinnerVoteAppState>();

class DinnerVoteApp extends StatefulWidget {

  DinnerVoteApp(): super(key: key);

  @override
  State<StatefulWidget> createState() => DinnerVoteAppState();
}

class DrawerItem {
  final String title;
  final IconData icon;
  final Widget page;

  DrawerItem(this.title, this.icon, this.page);
}

class DinnerVoteAppState extends State<DinnerVoteApp> {

  final items = [
    DrawerItem('Meals', Icons.info, MealListPage(key)),
    DrawerItem('People', Icons.person, PersonListPage(key)),
  ];

  var item;

  DinnerVoteAppState() {
    item = items[0];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinner Vote',
      theme: ThemeData(
        primaryColor: Color(0xFF3832AC),
        primaryColorLight: Color(0xFF705DDF),
        primaryColorDark: Color(0xFF000A7C),
        accentColor: Color(0xFFFFA866),
        cardColor: Color(0xFFDDDDDD),
      ),
      home: item.page,
    );
  }

  Drawer getDrawer(BuildContext context) {
    final tiles = <Widget>[];
    tiles.add(DrawerHeader(
      child: Text('Pages'),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
      ),
    ));
    for (var i = 0; i < items.length; i++) {
      final di = items[i];
      tiles.add(
        ListTile(
          leading: Icon(di.icon),
          title: Text(di.title),
          selected: item == items[i],
          onTap: () => _onSelectItem(context, i),
        )
      );
    }
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: tiles,
      ),
    );
  }

  _onSelectItem(BuildContext context, int index) {
    setState(() => item = items[index]);
    Navigator.of(context).pop();
  }
}
