import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _savedName;

  @override
  void initState() {
    super.initState();
    _loadName();
  }

  /// Загружаем имя из SharedPreferences
  Future<void> _loadName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username');
    });
  }

  /// Сохраняем имя в SharedPreferences
  Future<void> _saveName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _controller.text.trim());
    _loadName(); // Обновляем UI
  }

  /// Удаляем имя из SharedPreferences
  Future<void> _deleteName() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    _loadName(); // Обновляем UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _savedName == null || _savedName!.isEmpty
                  ? 'Введите имя'
                  : 'Сохраненное имя: $_savedName',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Введите имя',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveName,
              child: const Text('Сохранить'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _deleteName,
              child: const Text('Удалить'),
            ),
          ],
        ),
      ),
    );
  }
}
