part of 'task_list_bloc.dart';

enum TaskListStatus { loading, loaded, error }

class TaskListState {
  final List<TaskModel> taskList;
  final TaskListStatus status;
  TaskListState({
    this.taskList = const [],
    this.status = TaskListStatus.loading,
  });

  TaskListState copyWith({
    List<TaskModel>? taskList,
    TaskListStatus? status,
  }) {
    return TaskListState(
      taskList: taskList ?? this.taskList,
      status: status ?? this.status,
    );
  }
}

abstract class TaskListEvent {}

class TaskListFetch extends TaskListEvent {}

class TaskListTaskAdded extends TaskListEvent {
  final TaskModel addedTask;
  TaskListTaskAdded({required this.addedTask});
}

class TaskListUpdated extends TaskListEvent {
  final TaskModel updateTask;
  final int index;
  TaskListUpdated({
    required this.updateTask,
    required this.index,
  });
}

class TaskListAppClosed extends TaskListEvent {}
