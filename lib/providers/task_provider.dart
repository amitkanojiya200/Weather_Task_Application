import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  final Box<TaskModel> _taskBox = Hive.box<TaskModel>('tasks');

  List<TaskModel> get allTasks => _taskBox.values.toList();

  List<TaskModel> get todayTasks => allTasks
      .where((task) =>
          task.dateTime.day == DateTime.now().day &&
          task.dateTime.month == DateTime.now().month &&
          task.dateTime.year == DateTime.now().year)
      .toList();

  List<TaskModel> get upcomingTasks => allTasks
      .where((task) => task.dateTime.isAfter(DateTime.now()))
      .toList();

  List<TaskModel> get completedTasks =>
      allTasks.where((task) => task.isCompleted).toList();

  void addTask(TaskModel task) {
    _taskBox.add(task);
    notifyListeners();
  }

  void updateTask(TaskModel task) {
    task.save();
    notifyListeners();
  }

  void deleteTask(TaskModel task) {
    task.delete();
    notifyListeners();
  }

  void toggleComplete(TaskModel task) {
    task.isCompleted = !task.isCompleted;
    task.save();
    notifyListeners();
  }
}
