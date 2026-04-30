import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';
import 'package:task_tracker/presentation/screens/calendar_screen.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/task_detail_screen.dart';
import 'package:task_tracker/presentation/widgets/task_toolbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CalendarScreen()),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          const TaskToolbar(),

          const SizedBox(height: 8),

          Expanded(
            child: BlocBuilder<TaskCubit, List>(
              builder: (context, tasks) {
                final activeTasks = context.read<TaskCubit>().activeTasks;

                if (activeTasks.isEmpty) {
                  return const Center(child: Text("Нет активных задач"));
                }

                return ListView.builder(
                  itemCount: activeTasks.length,
                  itemBuilder: (context, index) {
                    final task = activeTasks[index];

                    return Card(
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
                          style: const TextStyle(fontWeight: FontWeight.bold),
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
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
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

      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(Icons.add),
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (_) => AddTaskScreen()),
      //     );
      //   },
      // ),
    );
  }
}
