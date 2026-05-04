import 'package:flutter/material.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';

class TaskCard extends StatelessWidget {
  final TaskModel task;
  final VoidCallback? onTap;

  const TaskCard({super.key, required this.task, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: getPriorityColor(task.priority),
          child: Text(
            task.priority[0],
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.category),
            Text(
              "${task.deadline.toLocal()}".split('.')[0],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Icon(
          task.isDone ? Icons.check_circle : Icons.arrow_forward_ios,
          color: task.isDone ? Colors.green : Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
