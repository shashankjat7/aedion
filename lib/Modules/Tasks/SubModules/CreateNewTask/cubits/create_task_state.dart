part of 'create_task_cubit.dart';

enum CreatedTaskStatus { editing, postingInProgress, postSuccess, postFailure }

class CreateTaskState {
  final String title;
  final String description;
  final CreatedTaskStatus status;
  final TaskModel? createdTask;

  const CreateTaskState({
    this.title = '',
    this.description = '',
    this.createdTask,
    this.status = CreatedTaskStatus.editing,
  });

  bool isTitleValid() => title.isNotEmpty;
  bool isDescriptionValid() => description.isNotEmpty;

  CreateTaskState copyWith({
    String? title,
    String? description,
    TaskModel? createdTask,
    CreatedTaskStatus? status,
  }) {
    return CreateTaskState(
      title: title ?? this.title,
      description: description ?? this.description,
      createdTask: createdTask ?? this.createdTask,
      status: status ?? this.status,
    );
  }
}
