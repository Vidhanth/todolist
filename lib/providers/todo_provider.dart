import 'package:flutter/material.dart';
import 'package:todolist/models/todo.dart';
import 'package:todolist/utils/db_helper.dart';

enum TaskToShow { all, done, pending }

class TodoProvider with ChangeNotifier {
  TodoProvider() {
    loadTodos();
  }

  bool loading = true;

  TaskToShow _taskToShow = TaskToShow.all;

  TaskToShow get taskToShow => _taskToShow;

  set taskToShow(newTaskToShow) {
    _taskToShow = newTaskToShow;
    notifyListeners();
  }

  String get noTaskMessage {
    if (_taskToShow == TaskToShow.all) {
      return 'Add some tasks to see them here!';
    }
    if (_taskToShow == TaskToShow.done) {
      return 'Complete some tasks to see them here!';
    }
    return 'You have no pending tasks!';
  }

  List<Todo> _todoList = [];
  List<Todo> get todoList => _todoList.where((element) {
        if (taskToShow == TaskToShow.all) return true;
        if (taskToShow == TaskToShow.done) return element.completed;
        return !element.completed;
      }).toList();
  DBHelper dbHelper = DBHelper.instance;

  Future<void> saveOrder() async {
    List<String> customOrder = [];
    for (Todo todo in _todoList) {
      customOrder.add(todo.id.toString());
    }
    await DBHelper.instance.saveToPrefs('list_order', customOrder);
  }

  Future<void> loadTodos() async {
    List<String>? customOrder = DBHelper.instance.getFromPrefs('list_order');
    _todoList = await dbHelper.loadTodos(customOrder: customOrder);
    if (customOrder == null) saveOrder();
    loading = false;
    notifyListeners();
  }

  Future<void> reorderTodos(int oldIndex, int newIndex) async {
    _todoList.insert(newIndex, _todoList.removeAt(oldIndex));
    notifyListeners();
    await saveOrder();
  }

  Future<Todo> addTodo(String text, int index) async {
    int id = await dbHelper.createTodo(text, index, false);
    Todo todo = Todo(id, text, index, false);
    _todoList.insert(0, todo);
    notifyListeners();
    await saveOrder();
    return todo;
  }

  Future<Todo> updateTodo(Todo newTodo) async {
    await dbHelper.updateTodo(newTodo);
    Todo todoToUpdate = _todoList.firstWhere((todo) => todo.id == newTodo.id);
    todoToUpdate.text = newTodo.text;
    todoToUpdate.colorIndex = newTodo.colorIndex;
    todoToUpdate.completed = newTodo.completed;
    int index = _todoList.indexWhere((todo) => todo.id == todoToUpdate.id);
    _todoList[index] = todoToUpdate;
    notifyListeners();
    return todoToUpdate;
  }

  Future<Todo> deleteTodo(int id) async {
    await dbHelper.deleteTodo(id);
    Todo todoToDelete = _todoList.firstWhere((todo) => todo.id == id);
    _todoList.removeWhere((todo) => todo.id == id);
    notifyListeners();
    await saveOrder();
    return todoToDelete;
  }
}
