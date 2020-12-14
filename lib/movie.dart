class Movie {
  int id;
  String name;
  String type;

  Movie(this.id, this.name, this.type);

  factory Movie.fromJson(dynamic json) {
    return Movie(
        json['id'] as int, json['name'] as String, json['type'] as String);
  }

  @override
  String toString() {
    return '{ ${this.id} , ${this.name}, ${this.type} }';
  }
}
