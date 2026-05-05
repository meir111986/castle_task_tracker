import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/domain/enums/category.dart';
import 'package:task_tracker/domain/enums/priority_ext.dart';
// import 'package:task_tracker/helpers/ui_helpers.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  TaskCubit() : super([]) {
    loadTasks();
  }

  final box = Hive.box<TaskModel>('tasks');
  Category? selectedCategory;
  String sortType = "None";

  String searchQuery = "";

  List<TaskModel> get activeTasks => state.where((t) => !t.isDone).toList();

  List<TaskModel> get completedTasks => state.where((t) => t.isDone).toList();

  void loadTasks() {
    var tasks = box.values.toList();

    if (searchQuery.isNotEmpty) {
      tasks = tasks
          .where(
            (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (selectedCategory != null) {
      tasks = tasks.where((t) => t.category == selectedCategory).toList();
    }

    if (sortType == "Priority") {
      tasks.sort((a, b) {
        if (a.isDone != b.isDone) {
          return a.isDone ? 1 : -1;
        }

        return b.priority.weight.compareTo(a.priority.weight);
      });
    } else if (sortType == "Date") {
      tasks.sort((a, b) {
        if (a.isDone != b.isDone) {
          return a.isDone ? 1 : -1;
        }

        return a.deadline.compareTo(b.deadline);
      });
    } else {
      tasks.sort((a, b) {
        if (a.isDone != b.isDone) {
          return a.isDone ? 1 : -1;
        }

        return 0;
      });
    }

    emit(tasks);
  }

  void addTask(TaskModel task) {
    box.add(task);
    loadTasks();
  }

  void updateTask(TaskModel task) {
    task.save();
    loadTasks();
  }

  void completeTask(TaskModel task) {
    task.isDone = true;
    task.save();
    loadTasks();
  }

  void deleteTask(TaskModel task) {
    task.delete();
    loadTasks();
  }

  void setCategory(Category? category) {
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
