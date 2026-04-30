import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/screens/calendar_screen.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/add_task_screen.dart';
import 'package:task_tracker/presentation/screens/edit_task_screen.dart';
import 'package:task_tracker/presentation/screens/task_detail_screen.dart';

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
          //  Поиск
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Поиск задач...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                context.read<TaskCubit>().search(value);
              },
            ),
          ),

          //  Фильтр + сортировка
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: context.read<TaskCubit>().selectedCategory,
                    decoration: const InputDecoration(
                      labelText: "Категория",
                      border: OutlineInputBorder(),
                    ),
                    items: ["All", "Work", "Personal"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<TaskCubit>().setCategory(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: context.read<TaskCubit>().sortType,
                    decoration: const InputDecoration(
                      labelText: "Сортировка",
                      border: OutlineInputBorder(),
                    ),
                    items: ["None", "Priority", "Date"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        context.read<TaskCubit>().setSort(value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          //  Статистика
          BlocBuilder<TaskCubit, List>(
            builder: (context, tasks) {
              final total = tasks.length;
              final done = tasks.where((task) => task.isDone).length;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Выполнено: $done / $total",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CircularProgressIndicator(
                          value: total == 0 ? 0 : done / total,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 8),

          //  Список задач
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
                        // trailing: Checkbox(
                        //   value: task.isDone,
                        //   onChanged: (_) {
                        //     context.read<TaskCubit>().toggleTask(task);
                        //   },
                        // ),
                        // onLongPress: () {
                        //   context.read<TaskCubit>().deleteTask(index);
                        // },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TaskDetailScreen(task: task),
                            ),
                          );
                        },
                        // trailing: Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     Checkbox(
                        //       value: task.isDone,
                        //       onChanged: (_) {
                        //         context.read<TaskCubit>().toggleTask(task);
                        //       },
                        //     ),
                        //     IconButton(
                        //       icon: const Icon(Icons.delete, color: Colors.red),
                        //       onPressed: () {
                        //         context.read<TaskCubit>().deleteTask(task);
                        //       },
                        //     ),
                        //   ],
                        // ),
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

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
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
