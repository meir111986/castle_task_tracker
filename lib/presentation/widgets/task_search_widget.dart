import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class TaskSearchWidget extends StatelessWidget {
  const TaskSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskCubit>();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: InputDecoration(
              hintText: "Поиск задач...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 4),
            ),
            style: TextStyle(fontSize: 14),

            onChanged: cubit.search,
          ),
        ),
      ],
    );
  }
}
