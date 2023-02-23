import 'package:aedion/Modules/Tasks/api/tasks_api.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class TaskListEvent {
  final TaskModel? task;
  const TaskListEvent({
    this.task,
  });
}

class TaskListFetch extends TaskListEvent {}

class TaskListTaskAdded extends TaskListEvent {
  const TaskListTaskAdded({super.task});
}

class TaskListUpdated extends TaskListEvent {
  final TaskModel updateTask;
  final int index;
  const TaskListUpdated({required this.updateTask, required this.index});
}

// class TaskListStarted extends TaskListEvent {}
//
// class TaskListLoaded extends TaskListEvent {}
//
// class TaskListFailed extends TaskListEvent {}

abstract class TaskListState {
  final List<TaskModel>? tasks;
  const TaskListState({
    this.tasks,
  });
}

class TaskListLoading extends TaskListState {
  const TaskListLoading({super.tasks});
}

class TaskListLoadingSuccess extends TaskListState {
  const TaskListLoadingSuccess({super.tasks});
}

class TaskListError extends TaskListState {
  const TaskListError({super.tasks});
}

class TaskListBloc extends Bloc<TaskListEvent, TaskListState> {
  TaskListBloc() : super(const TaskListLoading()) {
    on<TaskListFetch>(_fetchTaskList);
    on<TaskListTaskAdded>(_addTaskToList);
    on<TaskListUpdated>(_updateTask);
  }

  Future<void> _fetchTaskList(TaskListEvent event, Emitter<TaskListState> emit) async {
    List<TaskModel> taskList = await TasksApi().fetchTaskList();
    emit(TaskListLoadingSuccess(tasks: taskList));
  }

  void _addTaskToList(TaskListEvent event, Emitter<TaskListState> emit) async {
    List<TaskModel>? tasks = state.tasks;
    if (tasks == null) {
      emit(TaskListLoadingSuccess(tasks: [event.task!]));
      return;
    }
    tasks.add(event.task!);
    emit(TaskListLoadingSuccess(tasks: tasks));
  }

  void _updateTask(TaskListUpdated event, Emitter<TaskListState> emit) {
    List<TaskModel>? tasks = state.tasks;
    tasks![event.index] = event.updateTask;
    emit(TaskListLoadingSuccess(tasks: tasks));
  }
}
