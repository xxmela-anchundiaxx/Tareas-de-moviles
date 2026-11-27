import '../domain/task.dart';
import 'task_api_service.dart';
import 'task_repository.dart';

class RemoteTaskRepository implements TaskRepository {
  RemoteTaskRepository({TaskApiService? apiService})
    : _apiService = apiService ?? TaskApiService();

  final TaskApiService _apiService;
  List<Task> _tasks = [];

  @override
  Future<List<Task>> getTasks() async {
    _tasks = await _apiService.getTasks();
    return List.unmodifiable(_tasks);
  }

  @override
  void save(Task task) {
    _tasks = [
      for (final item in _tasks)
        if (item.id == task.id) task else item,
    ];
  }

  @override
  Future<Task> createTask(
    String title,
    String description,
    String priority,
  ) async {
    final response = await _apiService.createTask(title);
    final task = Task(
      id: response.id,
      title: title,
      description: description,
      priority: priority,
      isCompleted: false,
      userId: response.userId,
    );
    _tasks = [..._tasks, task];
    return task;
  }

  @override
  Future<void> updateTask(Task task) async {
    await _apiService.updateTask(task);
    save(task);
  }

  @override
  Future<void> deleteTask(int id) async {
    await _apiService.deleteTask(id);
    _tasks = _tasks.where((task) => task.id != id).toList();
  }
}
