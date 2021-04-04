class SubTasks {
  int taskId;
  int subTaskId;
  int subTaskStatus;
  String subTaskName;
  String subTaskDetail;
  String subTaskDate;
  String subTaskTime;

  SubTasks({
    this.taskId,
    this.subTaskStatus,
    this.subTaskName,
    this.subTaskDetail,
    this.subTaskDate,
    this.subTaskTime,
  });

  SubTasks.withId({
    this.taskId,
    this.subTaskId,
    this.subTaskStatus,
    this.subTaskName,
    this.subTaskDetail,
    this.subTaskDate,
    this.subTaskTime,
  });

  // to store data in database we need a toMap method
  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['taskId'] = taskId;
    if (subTaskId != null) {
      map['subTaskId'] = taskId;
    }
    map['subTaskStatus'] = subTaskStatus;
    map['subTaskName'] = subTaskName;
    map['subTaskDetail'] = subTaskDetail;
    map['subTaskDate'] = subTaskDate;
    map['subTaskTime'] = subTaskTime;
    return map;
  }

  // to recieve data from database we need a fromMap method
  // factory allows to return objects in your constuctors
  // fromMap method converts each map to a SubTask object
  factory SubTasks.fromMap(Map<String, dynamic> map) {
    return SubTasks.withId(
      taskId: map['taskId'],
      subTaskId: map['subTaskId'],
      subTaskStatus: map['subTaskStatus'],
      subTaskName: map['subTaskName'],
      subTaskDetail: map['subTaskDetail'],
      subTaskDate: map['subTaskDate'],
      subTaskTime: map['subTaskTime'],
    );
  }
}
