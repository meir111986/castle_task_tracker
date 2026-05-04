import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/calendar_screen.dart';
import 'package:task_tracker/presentation/screens/task_detail_screen.dart';
import 'package:task_tracker/presentation/widgets/task_card.dart';
import 'package:task_tracker/presentation/widgets/task_filter_sort_widget.dart';
import 'package:task_tracker/presentation/widgets/task_search_widget.dart';
import 'package:task_tracker/presentation/widgets/task_static_widget.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Все задачи"),
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
          // const TaskToolbar(),
          const TaskSearchWidget(),
          const TaskFilterSortWidget(),
          const TaskStaticWidget(),

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

                    return TaskCard(
                      task: task,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TaskDetailScreen(task: task),
                          ),
                        );
                      },
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
