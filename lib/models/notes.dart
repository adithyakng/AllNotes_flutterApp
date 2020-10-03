class Notes {
  DateTime id;
  DateTime createdOn;
  DateTime updatedOn;
  String title;
  String data;
  int favourite;

  Notes({this.id, this.createdOn, this.updatedOn, this.title, this.data,this.favourite = 0});

  Map<String, dynamic> toMap() {
    return {
      "id": id.toIso8601String(),
      "title": title,
      "data": data,
      "createdOn": createdOn.toIso8601String(),
      "updatedOn": updatedOn.toIso8601String(),
      "favourite": favourite,
    };
  }

  static Notes fromMap(Map<String, dynamic> note) {
    return new Notes(
      id: DateTime.parse(note['id']),
      title: note['title'],
      data: note['data'],
      createdOn:  DateTime.parse(note['createdOn']),
      updatedOn:  DateTime.parse(note['updatedOn']),
      favourite: note['favourite']
    );
  }
  
  int toggleFavourite(){
    this.favourite =  ~ this.favourite;  // change favourite
    return this.favourite;
  }
}
