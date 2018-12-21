class Person {
  int id;
  String name;

  Person(this.name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Person.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
  }
}
