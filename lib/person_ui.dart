import 'package:flutter/material.dart';
import 'main.dart';
import 'person.dart';
import 'db.dart';

class PersonListPage extends StatefulWidget {
  final GlobalKey<DinnerVoteAppState> appKey;

  PersonListPage(appKey) : appKey = appKey;

  @override
  _PersonListPageState createState() => _PersonListPageState();
}

class _PersonListPageState extends State<PersonListPage> {
  final _dinners = new List<Person>();
  final _db = DbHelper();

  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dinner Vote: People'),
      ),
      drawer: widget.appKey.currentState.getDrawer(context),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () => _createPerson(context),
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

  Widget _buildRow(Person person) {
    return ListTile(
      title: Text(
        person.name,
        style: Theme.of(context).textTheme.title,
      ),
      onTap: () => _editPerson(context, person),
    );
  }

  _createPerson(BuildContext context) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonPage(Person(""))),
    );
    if (result == 'save') {
      _loadPeople();
    }
  }

  _loadPeople() async {
    _db.getAllPeople().then((people) {
      setState(() {
        _dinners.clear();
        people.forEach((person) {
          _dinners.add(Person.fromMap(person));
        });
      });
    });
  }

  _editPerson(BuildContext context, Person person) async {
    String result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PersonPage(person)),
    );
    if (result == 'update' || result == 'delete') {
      _loadPeople();
    }
  }
}

class PersonPage extends StatefulWidget {
  final Person person;
  PersonPage(this.person);

  @override
  State<StatefulWidget> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle())),
      body: PersonBody(widget.person),
    );
  }

  String _screenTitle() {
    return (widget.person.id != null) ? 'Edit Person' : 'Add Person';
  }
}

class PersonBody extends StatefulWidget {
  // This needs to be separate from PersonPage to allow
  // SnackBars to work with the Scaffold in PersonPage
  final Person person;
  PersonBody(this.person);

  @override
  State<StatefulWidget> createState() => _PersonBodyState();
}

class _PersonBodyState extends State<PersonBody> {
  DbHelper db = new DbHelper();

  TextEditingController _name;

  @override
  initState() {
    super.initState();

    _name = new TextEditingController(text: widget.person.name);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(6.0),
      children: <Widget>[
        TextField(
          controller: _name,
          decoration: InputDecoration(labelText: 'Name', isDense: true),
          maxLength: 22,
        ),
        Padding(padding: new EdgeInsets.all(2.0)),
        _buildButtons(context),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    if (widget.person.id != null) {
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
        _deletePerson(context);
      },
    );
  }

  _deletePerson(BuildContext context) {
    db.deletePerson(widget.person.id).then((_) {
      Navigator.pop(context, 'delete');
    });
  }

  String _buttonTitle() {
    return (widget.person.id != null) ? 'Update' : 'Add';
  }

  IconData _buttonIcon() {
    return (widget.person.id != null) ? Icons.done : Icons.person_add;
  }

  Widget _buildButton(BuildContext context) {
    return FlatButton.icon(
      label: Text(_buttonTitle()),
      icon: Icon(_buttonIcon()),
      textColor: Theme.of(context).primaryColorDark,
      onPressed: () {
        if (widget.person.id != null) {
          _updatePerson(context);
        } else {
          _savePerson(context);
        }
      },
    );
  }

  String _getName() {
    return _name.text.trim();
  }

  _updatePerson(BuildContext context) {
    db
        .updatePerson(Person.fromMap({
      'id': widget.person.id,
      'name': _getName(),
    }))
        .then((_) {
      Navigator.pop(context, 'update');
    }).catchError((e) {
      final snackBar = SnackBar(content: Text('Name must be unique'));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  _savePerson(BuildContext context) {
    final name = _getName();
    if (name.length == 0)
      return;
    db.savePerson(Person(name)).then((_) {
      Navigator.pop(context, 'save');
    }).catchError((e) {
      final snackBar = SnackBar(content: Text('Name must be unique'));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }
}
