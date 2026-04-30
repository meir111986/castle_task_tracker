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
          // //  Поиск
          // Padding(
          //   padding: const EdgeInsets.all(12),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Поиск задач...",
          //       prefixIcon: const Icon(Icons.search),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     onChanged: (value) {
          //       context.read<TaskCubit>().search(value);
          //     },
          //   ),
          // ),

          // //  Фильтр + сортировка
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   child: Row(
          //     children: [
          //       Expanded(
          //         child: DropdownButtonFormField<String>(
          //           value: context.read<TaskCubit>().selectedCategory,
          //           decoration: const InputDecoration(
          //             labelText: "Категория",
          //             border: OutlineInputBorder(),
          //           ),
          //           items: ["All", "Work", "Personal"]
          //               .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          //               .toList(),
          //           onChanged: (value) {
          //             if (value != null) {
          //               context.read<TaskCubit>().setCategory(value);
          //             }
          //           },
          //         ),
          //       ),
          //       const SizedBox(width: 12),
          //       Expanded(
          //         child: DropdownButtonFormField<String>(
          //           value: context.read<TaskCubit>().sortType,
          //           decoration: const InputDecoration(
          //             labelText: "Сортировка",
          //             border: OutlineInputBorder(),
          //           ),
          //           items: ["None", "Priority", "Date"]
          //               .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          //               .toList(),
          //           onChanged: (value) {
          //             if (value != null) {
          //               context.read<TaskCubit>().setSort(value);
          //             }
          //           },
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(height: 12),

          // //  Статистика
          // BlocBuilder<TaskCubit, List>(
          //   builder: (context, tasks) {
          //     final total = tasks.length;
          //     final done = tasks.where((task) => task.isDone).length;

          //     return Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 12),
          //       child: Card(
          //         child: Padding(
          //           padding: const EdgeInsets.all(16),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children: [
          //               Text(
          //                 "Выполнено: $done / $total",
          //                 style: const TextStyle(
          //                   fontSize: 16,
          //                   fontWeight: FontWeight.bold,
          //                 ),
          //               ),
          //               CircularProgressIndicator(
          //                 value: total == 0 ? 0 : done / total,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     );
          //   },
          // ),
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
