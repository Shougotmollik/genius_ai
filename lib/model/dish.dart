class Dish {
  final int? id;
  final String? name;

  Dish({this.id, this.name});

  factory Dish.fromJson(Map<String, dynamic> json) =>
      Dish(id: json["id"], name: json["name"]);
}
