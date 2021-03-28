class Lists {
  int listId;
  String listName;

  Lists({
    this.listName,
  });

  Lists.withId({
    this.listId,
    this.listName,
  });

  // to store data in database we need a toMap method
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (listId != null) {
      map['listId'] = listId;
    }
    map['listName'] = listName;
    return map;
  }

  // to recieve data from database we need a fromMap method
  // factory allows to return objects in your constuctors
  // fromMap method converts each map to a List object
  factory Lists.fromMap(Map<String, dynamic> map) {
    return Lists.withId(
      listId: map['listId'],
      listName: map['listName'],
    );
  }
}
