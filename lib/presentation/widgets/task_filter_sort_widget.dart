import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class TaskFilterSortWidget extends StatelessWidget {
  const TaskFilterSortWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskCubit>();

    return Column(
      children: [
        // Фильтр + сортировка
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: cubit.selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Категория",
                    border: OutlineInputBorder(),
                  ),
                  items: ["All", "Work", "Personal"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      cubit.setCategory(value);
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: cubit.sortType,
                  decoration: const InputDecoration(
                    labelText: "Сортировка",
                    border: OutlineInputBorder(),
                  ),
                  items: ["None", "Priority", "Date"]
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      cubit.setSort(value);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
      ],
    );
  }
}
