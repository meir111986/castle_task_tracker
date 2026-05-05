import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;

  const TaskDetailScreen({super.key, required this.task});

  Future<bool> confirmDialog(
    BuildContext context, {
    required String title,
    required String content,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Отмена"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Да"),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text("Детали задачи")),
      appBar: AppBar(
        title: const Text("Детали задачи"),
        actions: [
          if (!task.isDone)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.lightGreen),
              tooltip: "Изменить",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditTaskScreen(task: task)),
                );
              },
            ),

          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: "Удалить",
            onPressed: () async {
              final confirmed = await confirmDialog(
                context,
                title: "Удаление задачи",
                content: "Действительно хотите удалить эту задачу?",
              );

              if (!confirmed) return;

              context.read<TaskCubit>().deleteTask(task);

              if (!context.mounted) return;

              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Задача удалена")));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      task.description.isEmpty
                          ? "Описание отсутствует"
                          : task.description,
                    ),

                    const Divider(height: 32),

                    Text("Приоритет: ${task.priorityRu}"),
                    Text("Категория: ${task.categoryRu}"),
                    // Text("Дедлайн: ${task.deadline.toString().split('.')[0]}"),
                    Text("Дедлайн: ${task.formattedDate}"),
                    Text(
                      "Статус: ${task.isDone ? 'Выполнена' : 'Не выполнена'}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle),
              label: Text(
                task.isDone ? "Уже подтверждено" : "Подтвердить выполнение",
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: task.isDone ? Colors.grey : Colors.lightGreen,
                foregroundColor: Colors.white,
              ),

              onPressed: task.isDone
                  ? null
                  : () async {
                      final confirmed = await confirmDialog(
                        context,
                        title: "Подтверждение",
                        content:
                            "Действительно хотите подтвердить, что задача выполнена?",
                      );

                      if (!confirmed) return;

                      context.read<TaskCubit>().completeTask(task);

                      if (!context.mounted) return;

                      Navigator.pop(context);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Задача отмечена как выполненная"),
                        ),
                      );
                    },
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
