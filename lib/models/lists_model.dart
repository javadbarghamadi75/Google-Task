class Lists {
  int listId;
  String listName;
  bool listStatus;

  Lists({
    this.listName,
    this.listStatus,
  });

  Lists.withId({
    this.listId,
    this.listName,
    this.listStatus,
  });

  // to store data in database we need a toMap method
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (listId != null) {
      map['listId'] = listId;
    }
    map['listName'] = listName;
    map['listStatus'] = listStatus == true ? 1 : 0;
    return map;
  }

  // to recieve data from database we need a fromMap method
  // factory allows to return objects in your constuctors
  // fromMap method converts each map to a List object
  factory Lists.fromMap(Map<String, dynamic> map) {
    return Lists.withId(
      listId: map['listId'],
      listName: map['listName'],
      listStatus: map['listStatus'] == 1 ? true : false,
    );
  }
}
