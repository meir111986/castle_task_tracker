import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class TaskStaticWidget extends StatelessWidget {
  const TaskStaticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<TaskCubit, List>(
          builder: (context, tasks) {
            final total = tasks.length;
            final done = tasks.where((t) => t.isDone).length;

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
      ],
    );
  }
}
