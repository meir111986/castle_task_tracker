import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/screens/calendar_screen.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/add_task_screen.dart';

Color getPriorityColor(String priority) {
  switch (priority) {
    case "High":
      return Colors.red;
    case "Medium":
      return Colors.orange;
    case "Low":
      return Colors.green;
    default:
      return Colors.grey;
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Task Tracker")),
      appBar: AppBar(
        title: Text("Task Tracker"),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_month),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CalendarScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, List>(
        builder: (context, tasks) {
          if (tasks.isEmpty) {
            return Center(child: Text("Нет задач"));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  // leading: CircleAvatar(child: Text(task.priority[0])),
                  leading: CircleAvatar(
                    backgroundColor: getPriorityColor(task.priority),
                    child: Text(
                      task.priority[0],
                      style: TextStyle(color: Colors.white),
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
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Checkbox(
                    value: task.isDone,
                    onChanged: (_) {
                      context.read<TaskCubit>().toggleTask(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
      ),
    );
  }
}
