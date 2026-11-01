import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Tarefas Flutter',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// ----------------------------------------------------
// TELA DE LOGIN
// ----------------------------------------------------
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController senhaController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bem Vindo, Mateus!\nMEU RA: 5555555',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.purple),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'email', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: senhaController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'senha', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size.fromHeight(50)),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const CalendarScreen()),
                  );
                },
                child: const Text('Entrar', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// TELA DE CALENDÁRIO
// ----------------------------------------------------
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendário de Tarefas')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Bem Vindo, Mateus!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: Center(
              child: CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                onDateChanged: (DateTime date) {
                  // Ação ao selecionar a data
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple, minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TaskListScreen()),
                );
              },
              child: const Text('Selecionar o dia', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// MODELO DE TAREFA
// ----------------------------------------------------
class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

// ----------------------------------------------------
// TELA DE LISTA DE TAREFAS
// ----------------------------------------------------
class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final List<Task> _tasks = [
    Task(title: 'Estudar Flutter', isCompleted: false),
    Task(title: 'Fazer atividades', isCompleted: true),
  ];

  void _sortTasks() {
    _tasks.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return a.title.compareTo(b.title);
      }
      return a.isCompleted ? 1 : -1; // Pendentes primeiro, concluídas depois
    });
  }

  void _addTaskDialog() {
    String newTitle = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: TextField(
            onChanged: (value) => newTitle = value,
            decoration: const InputDecoration(hintText: 'Digite o nome da tarefa'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newTitle.trim().isNotEmpty) {
                  setState(() {
                    _tasks.add(Task(title: newTitle, isCompleted: false));
                    _sortTasks();
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _sortTasks();
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text('Dia 11/11/2023', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(task.isCompleted ? 'Tarefa concluída' : 'Tarefa em andamento'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          onChanged: (bool? value) {
                            setState(() {
                              task.isCompleted = value ?? false;
                              _sortTasks();
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _tasks.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: _addTaskDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}