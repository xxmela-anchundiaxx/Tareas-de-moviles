import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'tasks_view_model.dart';

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final int? taskId;

  @override
  Widget build(BuildContext context) {
    final task = context.watch<TasksViewModel>().findTask(taskId);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de tarea')),
      body: task == null
          ? const Center(child: Text('No se encontró esta tarea.'))
          : ListView(
              padding: const EdgeInsets.all(24),
              children: [
                Text(
                  task.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                Text(task.description),
                const SizedBox(height: 16),
                Text('Prioridad: ${task.priority}'),
                Text(
                  task.isCompleted ? 'Estado: completada' : 'Estado: pendiente',
                ),
                Text('Usuario: ${task.userId}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    context.read<TasksViewModel>().toggleCompleted(task.id);
                  },
                  child: Text(
                    task.isCompleted
                        ? 'Marcar como pendiente'
                        : 'Marcar como completada',
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final controller = TextEditingController(text: task.title);
                    final newTitle = await showDialog<String>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Editar título'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(dialogContext),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(
                              dialogContext,
                              controller.text.trim(),
                            ),
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );
                    if (!context.mounted ||
                        newTitle == null ||
                        newTitle.length < 3) {
                      return;
                    }
                    try {
                      await context.read<TasksViewModel>().updateTask(
                        task.copyWith(title: newTitle),
                      );
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Tarea actualizada')),
                        );
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo actualizar'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Editar título'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: const Text('Eliminar tarea'),
                        content: Text('¿Eliminar ${task.title}?'),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: const Text('Cancelar'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            child: const Text('Eliminar'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed != true || !context.mounted) return;
                    try {
                      await context.read<TasksViewModel>().deleteTask(task.id);
                      if (context.mounted) context.pop();
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo eliminar la tarea'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Eliminar tarea'),
                ),
              ],
            ),
    );
  }
}
