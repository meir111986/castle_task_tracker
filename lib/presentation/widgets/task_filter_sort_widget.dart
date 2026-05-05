import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_tracker/domain/enums/category.dart';
import 'package:task_tracker/domain/enums/category_ext.dart';
import 'package:task_tracker/helpers/ui_helpers.dart';
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
                child: DropdownButtonFormField<Category?>(
                  value: cubit.selectedCategory,
                  decoration: const InputDecoration(
                    labelText: "Категория",
                    border: OutlineInputBorder(gapPadding: 0),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  style: const TextStyle(fontSize: 14, color: Colors.black),

                  items: [
                    const DropdownMenuItem(value: null, child: Text("Все")),
                    ...Category.values.map(
                      (e) =>
                          DropdownMenuItem(value: e, child: Text(e.categoryRu)),
                    ),
                  ],

                  onChanged: (value) {
                    cubit.setCategory(value);
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
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  ),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                  items: ["None", "Priority", "Date"]
                      .map(
                        (e) =>
                            DropdownMenuItem(value: e, child: Text(getSort(e))),
                      )
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
