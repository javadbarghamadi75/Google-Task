import 'dart:io';
import 'package:google_task/models/lists_model.dart';
import 'package:google_task/models/subtasks_model.dart';
import 'package:google_task/models/tasks_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // this creates a sigleton
  // then, database helper is only going to have ONE instance through the whole entire application
  static final DatabaseHelper instance = DatabaseHelper._instance();
  static Database _db;

  DatabaseHelper._instance();

  /// `---------------------- declaring table(s) columns ----------------------`
  ///  -------------------------    `Lists` table    --------------------------
  // listId | listName
  //   0        ''
  //// 1        ''
  //   2        ''
  //   3        ''
  String listsTable = 'lists_table';
  String colListId = 'listId';
  String colListName = 'listName';
  String colListStatus = 'listStatus';

  ///  -------------------------    `Tasks` table    --------------------------
  // listId | taskId | taskStatus | taskName | taskDetail | taskDate | taskTime
  //   0        ''         ''          ''          ''          ''        ''
  ////   1        ''         ''          ''          ''          ''        ''
  //   2        ''         ''          ''          ''          ''        ''
  //   3        ''         ''          ''          ''          ''        ''
  String tasksTable = 'tasks_table';

  /// this is a `foreign key from` from `Lists` Table
  //String colListId = 'listId';
  String colTaskId = 'taskId';
  String colTaskStatus = 'taskStatus';
  String colTaskName = 'taskName';
  String colTaskDetail = 'taskDetail';
  String colTaskDate = 'taskDate';
  String colTaskTime = 'taskTime';

  ///  -----------------------    `SubTasks` table    -------------------------
  // taskId | subTaskId | subTaskStatus | subTaskName | subTaskDetail | subTaskDate | subTaskTime
  //   0         ''            ''             ''             ''             ''            ''
  //// 1         ''            ''             ''             ''             ''            ''
  //   2         ''            ''             ''             ''             ''            ''
  //   3         ''            ''             ''             ''             ''            ''
  String subTasksTable = 'subTasks_table';

  /// this is a `foreign key from` from `Tasks` Table
  // String colTaskId = 'taskId';
  String colSubTaskId = 'subTaskId';
  String colSubTaskStatus = 'subTaskStatus';
  String colSubTaskName = 'subTaskName';
  String colSubTaskDetail = 'subTaskDetail';
  String colSubTaskDate = 'subTaskDate';
  String colSubTaskTime = 'subTaskTime';

  /// `------------------------------------------------------------------------`

  // a getter method for out database variable
  Future<Database> get db async {
    if (_db == null) {
      _db = await _initDb();
    }
    return _db;
  }

  // a method for create database if it doesn't exist
  Future<Database> _initDb() async {
    // we're going to make a directory
    Directory dir = await getApplicationDocumentsDirectory();
    String path = dir.path + 'google_task.db';
    final googleTaskDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return googleTaskDb;
  }

  /// `------------------------ CREATE TABLE(S) COLUMNS -----------------------`
  void _createDb(Database db, int version) async {
    ///  ------------------------    `Lists` table    -------------------------
    await db.execute(
      '''
        CREATE TABLE $listsTable(
          $colListId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colListName TEXT,
          $colListStatus INTEGER
          )
      ''',
    );

    ///  ------------------------    `Tasks` table    -------------------------
    await db.execute(
      '''
        CREATE TABLE $tasksTable(
          $colListId INTEGER,
          $colTaskId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colTaskStatus INTEGER,
          $colTaskName TEXT,
          $colTaskDetail TEXT,
          $colTaskDate TEXT,
          $colTaskTime TEXT,
          FOREIGN KEY ($colListId)
          REFERENCES $listsTable ($colListId) 
          ON UPDATE CASCADE
          ON DELETE CASCADE
          )
      ''',
    );

    ///  -----------------------    `SubTasks` table    -----------------------
    await db.execute(
      '''
        CREATE TABLE $subTasksTable(
          $colTaskId INTEGER,
          $colSubTaskId INTEGER PRIMARY KEY AUTOINCREMENT,
          $colSubTaskStatus INTEGER,
          $colSubTaskName TEXT,
          $colSubTaskDetail TEXT,
          $colSubTaskDate TEXT,
          $colSubTaskTime TEXT,
          FOREIGN KEY ($colTaskId)
          REFERENCES $tasksTable ($colTaskId) 
          ON UPDATE CASCADE
          ON DELETE CASCADE
        )
      ''',
    );
  }

  /// `------------------------------------------------------------------------`

  /// `------------------------- GET MAPS FROM DATABASE -----------------------`
  ///  -------------------------    `Lists` table    --------------------------
  /// a get method for `Lists` table to get data as map lists (default)
  /// getListsMapList is going to return all of the rows in our `Lists` table as maps
  Future<List<Map<String, dynamic>>> getListsMapList() async {
    // this call the getter we wrote up here
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(listsTable);
    return result;
  }

  ///  -------------------------    `Tasks` table    --------------------------
  /// a get method for `Tasks` table to get data as map lists (default)
  /// getTasksMapList is going to return all of out rows in out `Tasks` table as maps
  Future<List<Map<String, dynamic>>> getTasksMapList() async {
    // this call the getter we wrote up here
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(tasksTable);
    return result;
  }

  ///  ------------------------    `SubTasks` table    ------------------------
  /// a get method for `SubTasks` table to get data as map lists (default)
  /// getSubTasksMapList is going to return all of out rows in out `SubTasks` table as maps
  Future<List<Map<String, dynamic>>> getSubTasksMapList() async {
    // this call the getter we wrote up here
    Database db = await this.db;
    final List<Map<String, dynamic>> result = await db.query(subTasksTable);
    return result;
  }

  /// `------------------------------------------------------------------------`
  /// `-------------------------- CONVERT MAPS TO LIST ------------------------`
  ///  --------------------------    `Lists` table     ------------------------
  /// now we want to convert those maps (from getListsMapList method) to `List` objects
  Future<List<Lists>> getListsList() async {
    final List<Map<String, dynamic>> listsMapList = await getListsMapList();
    final List<Lists> listsList = [];

    /// converting each map to a `List` object
    listsMapList.forEach((listsMap) {
      listsList.add(Lists.fromMap(listsMap));
    });
    return listsList;
  }

  ///  --------------------------    `Tasks` table     ------------------------
  /// now we want to convert those maps (from getTasksMapList method) to `Task` objects
  Future<List<Tasks>> getTasksList() async {
    final List<Map<String, dynamic>> tasksMapList = await getTasksMapList();
    final List<Tasks> tasksList = [];

    /// converting each map to a `Task` object
    tasksMapList.forEach((tasksMap) {
      tasksList.add(Tasks.fromMap(tasksMap));
    });
    return tasksList;
  }

  ///  ------------------------    `SubTasks` table    ------------------------
  /// now we want to convert those maps (from getSubTasksMapList method) to `SubTask` objects
  Future<List<SubTasks>> getSubTasksList() async {
    final List<Map<String, dynamic>> subTasksMapList =
        await getSubTasksMapList();
    final List<SubTasks> subTasksList = [];

    /// converting each map to a `SubTask` object
    subTasksMapList.forEach((tasksMap) {
      subTasksList.add(SubTasks.fromMap(tasksMap));
    });
    return subTasksList;
  }

  /// `------------------------------------------------------------------------`

  /// this method helps `insert` a map of values into the specified table
  /// this method returns the `id of the last inserted row`
  /// `---------------------------- INSERT QUERIES ----------------------------`
  ///  -------------------------    `Lists` table     -------------------------
  Future<int> insertList(Lists lists) async {
    Database db = await this.db;

    /// we have to convert the `list` to a map because sqlite stores data as maps
    final int result = await db.insert(listsTable, lists.toMap());
    return result;
  }

  ///  -------------------------    `Tasks` table     -------------------------
  Future<int> insertTask(Tasks tasks) async {
    Database db = await this.db;

    /// we have to convert the `task` to a map because sqlite stores data as maps
    final int result = await db.insert(tasksTable, tasks.toMap());
    return result;
  }

  ///  ------------------------    `SubTasks` table     -----------------------
  Future<int> insertSubTask(SubTasks subTasks) async {
    Database db = await this.db;

    /// we have to convert the `subTask` to a map because sqlite stores data as maps
    final int result = await db.insert(subTasksTable, subTasks.toMap());
    return result;
  }

  /// `------------------------------------------------------------------------`

  /// convenience method for `updating` rows in the database.
  /// this method returns the `number of changes made`
  /// `---------------------------- UPDATE QUERIES ----------------------------`
  ///  -------------------------    `Lists` table     -------------------------
  Future<int> updateList(Lists lists) async {
    Database db = await this.db;
    final int result = await db.update(
      listsTable,
      lists.toMap(),
      where: '$colListId = ?',
      whereArgs: [lists.listId],
    );
    return result;
  }

  ///  -------------------------    `Tasks` table     -------------------------
  Future<int> updateTask(Tasks tasks) async {
    Database db = await this.db;
    final int result = await db.update(
      tasksTable,
      tasks.toMap(),
      where: '$colTaskId = ?',
      whereArgs: [tasks.taskId],
    );
    return result;
  }

  ///  ------------------------    `SubTasks` table     -----------------------
  Future<int> updateSubTask(SubTasks subTasks) async {
    Database db = await this.db;
    final int result = await db.update(
      subTasksTable,
      subTasks.toMap(),
      where: '$colSubTaskId = ?',
      whereArgs: [subTasks.subTaskId],
    );
    return result;
  }

  /// `------------------------------------------------------------------------`

  /// convenience method for `deleting` rows in the database.
  /// returns the `number of rows` affected if a whereClause is passed in, 0 otherwise.
  // to remove all rows and get a count, pass '1' as the whereClause.
  /// `---------------------------- DELETE QUERIES ----------------------------`
  ///  -------------------------    `Lists` table     -------------------------
  Future<int> deleteList(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      listsTable,
      where: '$colListId = ?',
      whereArgs: [id],
    );
    return result;
  }

  ///  -------------------------    `Tasks` table     -------------------------
  Future<int> deleteTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      tasksTable,
      where: '$colTaskId = ?',
      whereArgs: [id],
    );
    return result;
  }

  ///  ------------------------    `SubTasks` table     -----------------------
  Future<int> deleteSubTask(int id) async {
    Database db = await this.db;
    final int result = await db.delete(
      subTasksTable,
      where: '$colSubTaskId = ?',
      whereArgs: [id],
    );
    return result;
  }

  /// `------------------------------------------------------------------------`
}
