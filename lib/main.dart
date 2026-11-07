import 'package:flutter/material.dart';

// MODELO DE TAREA
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
  });

  final int id;
  final String title;
  final String description;
  final String priority;
  final bool isCompleted;

  Task copyWith({bool? isCompleted}) {
    return Task(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

// TAREAS DE EJEMPLO
const demoTasks = [
  Task(
    id: 1,
    title: 'Leer documentación',
    description: 'Revisar ListView.builder',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 2,
    title: 'Diseñar la pantalla',
    description: 'Definir la tarjeta de tarea',
    priority: 'Media',
    isCompleted: false,
  ),
  Task(
    id: 3,
    title: 'Preparar evidencia',
    description: 'Tomar captura del avance',
    priority: 'Baja',
    isCompleted: true,
  ),
  Task(
    id: 4,
    title: 'Organizar el backlog',
    description: 'Priorizar pendientes',
    priority: 'Alta',
    isCompleted: false,
  ),
  Task(
    id: 5,
    title: 'Revisar código',
    description: 'Ejecutar flutter analyze',
    priority: 'Media',
    isCompleted: false,
  ),
];

// INICIO DE LA APLICACIÓN
void main() {
  runApp(const TaskFlowApp());
}

// APLICACIÓN PRINCIPAL
class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

// PANTALLA PRINCIPAL
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final String studentName = 'Melanie Anchundia';

  final String courseName = 'Desarrollo de aplicaciones móviles';

  final String motivationalMessage =
      '¡Organiza tus tareas y alcanza tus metas!';

  late List<Task> tasks;

  final int dailyGoal = 5;

  @override
  void initState() {
    super.initState();
    tasks = List<Task>.from(demoTasks);
  }

  // CONTAR TAREAS PENDIENTES
  int get pendingTasks => tasks.where((task) => !task.isCompleted).length;

  // CONTAR TAREAS COMPLETADAS
  int get completedTasks => tasks.where((task) => task.isCompleted).length;

  // AGREGAR TAREA
  void _addTask() {
    setState(() {
      final newId = tasks.isEmpty
          ? 1
          : tasks.map((task) => task.id).reduce((a, b) => a > b ? a : b) + 1;

      tasks.add(
        Task(
          id: newId,
          title: 'Nueva tarea $newId',
          description: 'Tarea agregada desde TaskFlow',
          priority: 'Media',
          isCompleted: false,
        ),
      );
    });
  }

  // COMPLETAR UNA TAREA
  void _completeTask() {
    final index = tasks.indexWhere((task) => !task.isCompleted);

    if (index == -1) {
      return;
    }

    setState(() {
      tasks[index] = tasks[index].copyWith(isCompleted: true);
    });
  }

  // ABRIR PANTALLA DE TAREAS
  void _openTaskList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskListScreen(tasks: tasks)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusMessage = pendingTasks == 0
        ? '¡Excelente! No tienes tareas pendientes.'
        : 'Aún tienes tareas por organizar.';

    final double progress = (completedTasks / dailyGoal).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.task_alt, size: 56, color: Colors.indigo),

          const SizedBox(height: 24),

          // SALUDO
          Text(
            '¡Hola, $studentName!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),

          const SizedBox(height: 12),

          Text('Bienvenido/a a $courseName.'),

          const SizedBox(height: 12),

          Text(
            motivationalMessage,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.indigo,
            ),
          ),

          const SizedBox(height: 24),

          Text(statusMessage),

          const SizedBox(height: 20),

          // TAREAS PENDIENTES
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.pending_actions, color: Colors.indigo),
                  const SizedBox(width: 12),
                  Text('Tareas pendientes: $pendingTasks'),
                ],
              ),
            ),
          ),

          // TAREAS COMPLETADAS
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  const SizedBox(width: 12),
                  Text('Tareas completadas: $completedTasks'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // META DIARIA
          Text('Mi meta diaria', style: Theme.of(context).textTheme.titleLarge),

          const SizedBox(height: 12),

          Text('$completedTasks de $dailyGoal tareas completadas'),

          const SizedBox(height: 12),

          LinearProgressIndicator(
            value: progress,
            minHeight: 12,
            borderRadius: BorderRadius.circular(10),
            color: Colors.indigo,
            backgroundColor: Colors.indigo.shade100,
          ),

          const SizedBox(height: 12),

          Text(
            'Progreso: ${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),

          const SizedBox(height: 24),

          // BOTONES
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton.icon(
                onPressed: _addTask,
                icon: const Icon(Icons.add),
                label: const Text('Agregar tarea'),
              ),

              OutlinedButton.icon(
                onPressed: pendingTasks == 0 ? null : _completeTask,
                icon: const Icon(Icons.done),
                label: const Text('Completar una tarea'),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // BOTÓN PARA ABRIR LA LISTA
          ElevatedButton.icon(
            onPressed: _openTaskList,
            icon: const Icon(Icons.list),
            label: const Text('Ver mis tareas'),
          ),

          const SizedBox(height: 24),

          // MENSAJE AL ALCANZAR LA META
          if (completedTasks >= dailyGoal)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '¡Felicidades! Has alcanzado tu meta diaria.',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// COMPONENTE TASKCARD
class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
          color: task.isCompleted ? Colors.green : null,
        ),

        title: Text(task.title),

        subtitle: Text('${task.priority} · ${task.description}'),

        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

// NUEVA PANTALLA: LISTA DE TAREAS
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key, this.tasks = demoTasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return TaskCard(task: task);
        },
      ),
    );
  }
}
