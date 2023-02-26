import 'dart:async';

import 'package:aedion/Modules/Tasks/SubModules/TaskDetails/services/clock.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:bloc/bloc.dart';

class OngoingTaskListState {
  final List<TaskModel> ongoingTaskList;
  OngoingTaskListState({
    this.ongoingTaskList = const [],
  });

  OngoingTaskListState copyWith({
    List<TaskModel>? ongoingTaskList,
  }) {
    return OngoingTaskListState(
      ongoingTaskList: ongoingTaskList ?? this.ongoingTaskList,
    );
  }
}

abstract class OngoingTaskListEvent {}

class OngoingTaskAdded extends OngoingTaskListEvent {
  final TaskModel addedOngoingTask;
  OngoingTaskAdded({
    required this.addedOngoingTask,
  });
}

class OngoingTaskRemoved extends OngoingTaskListEvent {
  final TaskModel removedOngoingTask;
  OngoingTaskRemoved({
    required this.removedOngoingTask,
  });
}

class OngoingTaskListBloc extends Bloc<OngoingTaskListEvent, OngoingTaskListState> {
  Clock _clock = const Clock();
  final List<StreamSubscription<int>> _clockSubscriptionList = [];

  OngoingTaskListBloc() : super(OngoingTaskListState()) {
    on<OngoingTaskAdded>(_addOngoingTask);
    on<OngoingTaskRemoved>(_removeOngoingTask);
  }

  @override
  Future<void> close() {
    for (var i in _clockSubscriptionList) {
      i.cancel();
    }
    return super.close();
  }

  Future<void> _addOngoingTask(OngoingTaskAdded event, Emitter<OngoingTaskListState> emit) async {
    List<int> tempStartTimes = [];
    for (var task in state.ongoingTaskList) {
      tempStartTimes.add(task.timeSpent);
    }
    List<Stream<int>> streamList = _clock.tickList(
      ticksList: tempStartTimes,
    );
    for (var i in _clockSubscriptionList) {
      i.cancel();
    }
    for (int i = 0; i < streamList.length; i++) {
      _clockSubscriptionList.add(streamList[i].listen((duration) {
        state.ongoingTaskList[i] = state.ongoingTaskList[i].copyWith(timeSpent: duration);
        emit(state);
      }));
    }
  }

  // void _onClockTicked(int duration, int index) {
  //   state.ongoingTaskList[index] = state.ongoingTaskList[index].copyWith(timeSpent: duration);
  //   emit(state);
  // }

  void _removeOngoingTask(OngoingTaskRemoved event, Emitter<OngoingTaskListState> emit) async {
    for (var i in state.ongoingTaskList) {
      if (i.taskId == event.removedOngoingTask.taskId) {
        state.ongoingTaskList.remove(i);
        break;
      }
    }
    emit(state);
  }
}
