import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task_tracker/data/models/task_model.dart';

class TaskCubit extends Cubit<List<TaskModel>> {
  TaskCubit() : super([]) {
    loadTasks();
  }

  final box = Hive.box<TaskModel>('tasks');

  void loadTasks() {
    var tasks = box.values.toList();

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
}
