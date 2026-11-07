import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ======================================
// 1. MODELO DE TAREA
// ======================================

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

// ======================================
// 2. TAREAS DE EJEMPLO
// ======================================

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

// ======================================
// 3. ADMINISTRACIÓN DE TAREAS
// ======================================

class TaskStore extends ChangeNotifier {
  final List<Task> _tasks = List<Task>.from(demoTasks);

  List<Task> get tasks => List.unmodifiable(_tasks);

  int get pendingTasks => _tasks.where((task) => !task.isCompleted).length;

  int get completedTasks => _tasks.where((task) => task.isCompleted).length;

  Task? findTask(int id) {
    for (final task in _tasks) {
      if (task.id == id) {
        return task;
      }
    }
    return null;
  }

  void addTask() {
    final newId = _tasks.isEmpty
        ? 1
        : _tasks.map((task) => task.id).reduce((a, b) => a > b ? a : b) + 1;

    _tasks.add(
      Task(
        id: newId,
        title: 'Nueva tarea $newId',
        description: 'Tarea agregada desde TaskFlow',
        priority: 'Media',
        isCompleted: false,
      ),
    );

    notifyListeners();
  }

  void completeTask() {
    final index = _tasks.indexWhere((task) => !task.isCompleted);

    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(isCompleted: true);

    notifyListeners();
  }

  void toggleTask(int id) {
    final index = _tasks.indexWhere((task) => task.id == id);

    if (index == -1) {
      return;
    }

    _tasks[index] = _tasks[index].copyWith(
      isCompleted: !_tasks[index].isCompleted,
    );

    notifyListeners();
  }
}

final taskStore = TaskStore();

// ======================================
// 4. CONFIGURACIÓN DE GOROUTER
// ======================================

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TaskListScreen()),
    GoRoute(
      path: '/task/:id',
      builder: (context, state) {
        final taskId = int.tryParse(state.pathParameters['id'] ?? '');

        return TaskDetailScreen(taskId: taskId ?? -1);
      },
    ),
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
  ],
);

// ======================================
// 5. INICIO DE LA APLICACIÓN
// ======================================

void main() {
  runApp(const TaskFlowApp());
}

// ======================================
// 6. APLICACIÓN PRINCIPAL
// ======================================

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TaskFlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

// ======================================
// 7. PANTALLA DE BIENVENIDA
// ======================================

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

  final int dailyGoal = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: ListenableBuilder(
        listenable: taskStore,
        builder: (context, child) {
          final pendingTasks = taskStore.pendingTasks;
          final completedTasks = taskStore.completedTasks;

          final double progress = (completedTasks / dailyGoal).clamp(0.0, 1.0);

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Icon(Icons.task_alt, size: 60, color: Colors.indigo),

              const SizedBox(height: 20),

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
                  color: Colors.indigo,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                pendingTasks == 0
                    ? '¡Excelente! No tienes tareas pendientes.'
                    : 'Aún tienes tareas por organizar.',
              ),

              const SizedBox(height: 20),

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

              Text(
                'Mi meta diaria',
                style: Theme.of(context).textTheme.titleLarge,
              ),

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

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: taskStore.addTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar tarea'),
                  ),

                  OutlinedButton.icon(
                    onPressed: pendingTasks == 0
                        ? null
                        : taskStore.completeTask,
                    icon: const Icon(Icons.done),
                    label: const Text('Completar una tarea'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: () {
                  context.go('/');
                },
                icon: const Icon(Icons.list),
                label: const Text('Ver mis tareas'),
              ),

              const SizedBox(height: 20),

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
          );
        },
      ),
    );
  }
}

// ======================================
// 8. COMPONENTE TASKCARD
// ======================================

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, this.onTap});

  final Task task;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,

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

// ======================================
// 9. PANTALLA DE LISTA DE TAREAS
// ======================================

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: 'Inicio',
            onPressed: () {
              context.go('/welcome');
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),

      body: ListenableBuilder(
        listenable: taskStore,
        builder: (context, child) {
          final tasks = taskStore.tasks;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return TaskCard(
                task: task,
                onTap: () {
                  context.push('/task/${task.id}');
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: taskStore.addTask,
        tooltip: 'Agregar tarea',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ======================================
// 10. PANTALLA DE DETALLE DE TAREA
// ======================================

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de tarea'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),

      body: ListenableBuilder(
        listenable: taskStore,
        builder: (context, child) {
          final task = taskStore.findTask(taskId);

          if (task == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Tarea no encontrada'),
                  const SizedBox(height: 16),
                  FilledButton.tonalIcon(
                    onPressed: () => context.go('/'),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver al listado'),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 16),

                Text(task.description),

                const SizedBox(height: 16),

                Chip(label: Text('Prioridad: ${task.priority}')),

                const SizedBox(height: 12),

                Text(
                  task.isCompleted ? 'Estado: completada' : 'Estado: pendiente',
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: () {
                    taskStore.toggleTask(task.id);
                  },
                  icon: Icon(
                    task.isCompleted ? Icons.undo : Icons.check_circle,
                  ),
                  label: Text(
                    task.isCompleted
                        ? 'Marcar como pendiente'
                        : 'Completar tarea',
                  ),
                ),

                const Spacer(),

                FilledButton.tonalIcon(
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go('/');
                    }
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Volver al listado'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
