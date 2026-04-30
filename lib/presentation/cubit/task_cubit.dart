import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker/data/models/task_model.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  TaskCubit() : super([]) {
    loadTasks();
  }

  final box = Hive.box<TaskModel>('tasks');
  String selectedCategory = "All";
  String sortType = "None";

  String searchQuery = "";

  void loadTasks() {
    var tasks = box.values.toList();

    if (searchQuery.isNotEmpty) {
      tasks = tasks
          .where(
            (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (selectedCategory != "All") {
      tasks = tasks.where((t) => t.category == selectedCategory).toList();
    }

    if (sortType == "Priority") {
      tasks.sort((a, b) => b.priority.compareTo(a.priority));
    } else if (sortType == "Date") {
      tasks.sort((a, b) => a.deadline.compareTo(b.deadline));
    }

    emit(tasks);
  }

  void addTask(TaskModel task) {
    box.add(task);
    loadTasks();
  }

  void toggleTask(int index) {
    final task = box.getAt(index);

    if (task != null) {
      task.isDone = !task.isDone;
      task.save();
      loadTasks();
    }
  }

  void deleteTask(int index) {
    box.deleteAt(index);
    loadTasks();
  }

  void setCategory(String category) {
    selectedCategory = category;
    loadTasks();
  }

  void setSort(String sort) {
    sortType = sort;
    loadTasks();
  }

  void search(String query) {
    searchQuery = query;
    loadTasks();
  }
}
