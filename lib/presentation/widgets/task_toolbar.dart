import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';

class TaskToolbar extends StatelessWidget {
  const TaskToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<TaskCubit>();

    return Column(
      children: [
        // Поиск
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
            onChanged: cubit.search,
          ),
        ),

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

        const SizedBox(height: 12),

        // Статистика
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
