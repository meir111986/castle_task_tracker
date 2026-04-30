import 'package:flutter/material.dart';
import 'package:task_tracker/presentation/screens/add_task_screen.dart';
import 'package:task_tracker/presentation/screens/calendar_screen.dart';
import 'package:task_tracker/presentation/screens/home_screen.dart';
import 'package:task_tracker/presentation/screens/completed_screen.dart';
import 'package:task_tracker/presentation/screens/all_tasks_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final screens = [
    const HomeScreen(), // активные
    const CompletedScreen(), // выполненные
    const AllTasksScreen(), // все
    CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddTaskScreen()),
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "Активные"),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: "Выполненные",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.all_inbox), label: "Все"),
        ],
      ),
    );
  }
}
