import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/task_detail_screen.dart';
import 'package:task_tracker/presentation/widgets/task_toolbar.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Все задачи")),

      body: Column(
        children: [
          const TaskToolbar(),

          const SizedBox(height: 8),

          // 📋 Список
          Expanded(
            child: BlocBuilder<TaskCubit, List>(
              builder: (context, tasks) {
                if (tasks.isEmpty) {
                  return const Center(child: Text("Нет задач"));
                }

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];

                    return
                    // ListTile(
                    //   title: Text(task.title),
                    //   subtitle: Text(task.category),
                    // );
                    Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
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
                            decoration: task.isDone
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task.category),
                            Text(
                              "${task.deadline.toLocal()}".split(' ')[0],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                        },

                        trailing: Icon(
                          task.isDone
                              ? Icons.check_circle
                              : Icons.arrow_forward_ios,
                          color: task.isDone ? Colors.green : Colors.grey,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
