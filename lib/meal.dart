class Meal {
  int id;
  String title;
  String description;
  int on_menu = 0;

  Meal(this.title, this.description);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'description': description,
      'on_menu': on_menu,
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
    on_menu = map['on_menu'];
  }
}
