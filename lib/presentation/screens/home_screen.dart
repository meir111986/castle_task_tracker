import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:task_tracker/helpers/ui_helpers.dart';
import 'package:task_tracker/presentation/screens/calendar_screen.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/task_detail_screen.dart';
import 'package:task_tracker/presentation/widgets/task_card.dart';
import 'package:task_tracker/presentation/widgets/task_filter_sort_widget.dart';
import 'package:task_tracker/presentation/widgets/task_search_widget.dart';
import 'package:task_tracker/presentation/widgets/task_static_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Активные задачи"),
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
