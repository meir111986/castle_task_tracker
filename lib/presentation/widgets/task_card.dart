import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  Future<bool> confirmDelete(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Удалить задачу?"),
        content: const Text("Вы уверены?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Отмена"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Удалить"),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void showActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.check),
            title: const Text("Отметить выполненной"),
            onTap: () {
              context.read<TaskCubit>().completeTask(task);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text("Удалить"),
            onTap: () async {
              Navigator.pop(context);
              final confirmed = await confirmDelete(context);
              if (!confirmed) return;

              context.read<TaskCubit>().deleteTask(task);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.key),
      direction: DismissDirection.endToStart,

      // 🔴 фон при свайпе
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),

      confirmDismiss: (_) async {
        return await confirmDelete(context);
      },

      onDismissed: (_) {
        context.read<TaskCubit>().deleteTask(task);
      },

      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: ListTile(
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: task.isDone
                  ? Colors.grey
                  : getPriorityColor(task.priority),
            ),
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Text(
              task.priority[0],
              style: const TextStyle(color: Colors.white),
            ),
          ),

          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? Colors.grey : Colors.black,
            ),
            child: Text(task.title),
          ),

          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(task.category),
              Text(getCategory(task.category)),
              Text(
                "${task.deadline.toLocal()}".split('.')[0],
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),

          trailing: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              task.isDone ? Icons.check_circle : Icons.arrow_forward_ios,
              key: ValueKey(task.isDone),
              color: task.isDone ? Colors.green : Colors.grey,
            ),
          ),

          onTap: onTap,

          // 👇 long press меню
          onLongPress: () => showActions(context),
        ),
      ),
    );
  }
}
