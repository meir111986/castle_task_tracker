import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  TaskCubit() : super([]) {
    loadTasks();
  }

  final box = Hive.box<TaskModel>('tasks');
  String selectedCategory = "All";
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

    if (selectedCategory != "All") {
      tasks = tasks.where((t) => t.category == selectedCategory).toList();
    }

    if (sortType == "Priority") {
      tasks.sort((a, b) {
        // сначала невыполненные
        if (a.isDone != b.isDone) {
          return a.isDone ? 1 : -1;
        }

        // потом по приоритету
        return getPriorityValue(
          b.priority,
        ).compareTo(getPriorityValue(a.priority));
      });
    } else if (sortType == "Date") {
      tasks.sort((a, b) {
        // сначала невыполненные
        if (a.isDone != b.isDone) {
          return a.isDone ? 1 : -1;
        }

        // потом по дате
        return a.deadline.compareTo(b.deadline);
      });
    } else {
      tasks.sort((a, b) {
        // даже без сортировки выполненные вниз
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

  void toggleTask(TaskModel task) {
    task.isDone = !task.isDone;
    task.save();
    loadTasks();
  }

  // void toggleTask(int index) {
  //   final task = box.getAt(index);

  //   if (task != null) {
  //     task.isDone = !task.isDone;
  //     task.save();
  //     loadTasks();
  //   }
  // }

  void completeTask(TaskModel task) {
    task.isDone = true;
    task.save();
    loadTasks();
  }

  void deleteTask(TaskModel task) {
    task.delete();
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
