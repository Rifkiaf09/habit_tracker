import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../widgets/habit_tile.dart';
import 'add_habit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> _habits = [];

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsData = prefs.getString('habits');
    if (habitsData != null) {
      setState(() {
        _habits.clear();
        _habits.addAll(
          List<Map<String, dynamic>>.from(json.decode(habitsData)),
        );
      });
    }
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('habits', json.encode(_habits));
  }

  void _toggleHabit(int index) {
    setState(() {
      _habits[index]['done'] = !_habits[index]['done'];
    });
    _saveHabits();
  }

  void _deleteHabit(int index) {
    setState(() {
      _habits.removeAt(index);
    });
    _saveHabits();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Habit dihapus')));
  }

  void _navigateToAddHabit() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddHabitPage()),
    );
    if (result != null && result is String && result.isNotEmpty) {
      setState(() {
        _habits.add({'title': result, 'done': false});
      });
      _saveHabits();
    }
  }

  void _navigateToStats() {
    Navigator.pushNamed(context, '/stats', arguments: _habits);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habit Tracker'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: _navigateToStats,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (_habits.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: size.height * 0.2,
                    horizontal: 20,
                  ),
                  child: const Text(
                    'Belum ada habit. Tambahkan sekarang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habit: _habits[index]['title'],
                    completed: _habits[index]['done'],
                    onChanged: (_) => _toggleHabit(index),
                    onDismissed: (direction) => _deleteHabit(index),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
