import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_tracker/data/models/task_model.dart';
import 'package:task_tracker/domain/enums/category_adapter.dart';
import 'package:task_tracker/domain/enums/priority_adapter.dart';
import 'package:task_tracker/notification_service.dart';
import 'package:task_tracker/presentation/cubit/task_cubit.dart';
import 'package:task_tracker/presentation/screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.initFlutter();

  Hive.registerAdapter(PriorityAdapter());
  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TaskModelAdapter());

  // await Hive.deleteBoxFromDisk('tasks');
  await Hive.openBox<TaskModel>('tasks');

  await NotificationService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.light,
        ),
        // home: HomeScreen(),
        home: MainScreen(),
      ),
    );
  }
}
