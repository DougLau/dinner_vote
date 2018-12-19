class Meal {
  int id;
  String title;
  String description;
  String tags;

  Meal(this.title, this.description);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  Meal.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    title = map['title'];
    description = map['description'];
  }

  bool hasTag(String tag) {
    return (tag == 'Chicken');
  }
}
