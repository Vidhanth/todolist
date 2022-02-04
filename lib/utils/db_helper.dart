import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todolist/models/todo.dart';

class DBHelper {
  DBHelper._privateConsstructor();
  static final DBHelper instance = DBHelper._privateConsstructor();

  static const _fileName = 'todolist.db';
  static const _tableName = 'todolist';
  static const todoId = 'id';
  static const todoText = 'text';
  static const todoColorIndex = 'color';
  static const todoCompleted = 'completed';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, _fileName),
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      create table $_tableName (
        $todoId integer primary key,
        $todoText text not null,
        $todoColorIndex int not null,
        $todoCompleted boolean default false
      )
    ''');
  }

  Future<List<Todo>> loadTodos({List<String>? customOrder}) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> todoListRaw = await db.query(_tableName);
    List<Todo> todoList = [];
    if (customOrder != null) {
      for (String id in customOrder) {
        Map<String, dynamic> todo = todoListRaw
            .singleWhere((todoItem) => todoItem[todoId] == int.parse(id));
        todoList.add(Todo(
          todo[todoId],
          todo[todoText],
          todo[todoColorIndex],
          todo[todoCompleted] == 1,
        ));
      }
    } else {
      for (var todo in todoListRaw) {
        todoList.add(Todo(
          todo[todoId],
          todo[todoText],
          todo[todoColorIndex],
          todo[todoCompleted] == 1,
        ));
      }
    }
    return todoList;
  }

  Future<int> createTodo(String todo, int color, bool completed) async {
    Database db = await instance.database;
    return await db.insert(_tableName, {
      todoText: todo,
      todoColorIndex: color,
      todoCompleted: completed ? 1 : 0,
    });
  }

  Future<int> updateTodo(Todo todo) async {
    Database db = await instance.database;
    return await db.update(
      _tableName,
      {
        todoText: todo.text,
        todoColorIndex: todo.colorIndex,
        todoCompleted: todo.completed ? 1 : 0,
      },
      where: '$todoId = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(int id) async {
    Database db = await instance.database;
    return await db.delete(
      _tableName,
      where: '$todoId = ?',
      whereArgs: [id],
    );
  }
}
