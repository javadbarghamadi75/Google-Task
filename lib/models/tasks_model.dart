class Tasks {
  int listId;
  int taskId;
  int taskStatus;
  String taskName;
  String taskDetail;
  String taskDate;
  String taskTime;

  Tasks({
    this.listId,
    this.taskStatus,
    this.taskName,
    this.taskDetail,
    this.taskDate,
    this.taskTime,
  });

  Tasks.withId({
    this.listId,
    this.taskId,
    this.taskStatus,
    this.taskName,
    this.taskDetail,
    this.taskDate,
    this.taskTime,
  });

  // to store data in database we need a toMap method
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['listId'] = listId;
    if (taskId != null) {
      map['taskId'] = taskId;
    }
    map['taskStatus'] = taskStatus;
    map['taskName'] = taskName;
    map['taskDetail'] = taskDetail;
    map['taskDate'] = taskDate;
    map['taskTime'] = taskTime;
    return map;
  }

  // to recieve data from database we need a fromMap method
  // factory allows to return objects in your constuctors
  // fromMap method converts each map to a Task object
  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks.withId(
      listId: map['listId'],
      taskId: map['taskId'],
      taskStatus: map['taskStatus'],
      taskName: map['taskName'],
      taskDetail: map['taskDetail'],
      taskDate: map['taskDate'],
      taskTime: map['taskTime'],
    );
  }
}
