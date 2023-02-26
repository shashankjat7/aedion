import 'dart:developer';

import 'package:aedion/Modules/Tasks/SubModules/TaskDetails/views/task_details_view.dart';
import 'package:aedion/Modules/Tasks/blocs/task_list_bloc.dart';
import 'package:aedion/Modules/Tasks/SubModules/CreateNewTask/views/create_task_view.dart';
import 'package:aedion/Modules/Tasks/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//TODO: why not just make the task details global

class TaskListPageView extends StatelessWidget {
  const TaskListPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: const SafeArea(
        child: TaskListView(),
      ),
    );
  }
}

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'create_task_button',
        onPressed: () async {
          final TaskModel? createdTask = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTaskPageView(),
            ),
          );
          log('created task returned was : $createdTask');
          if (createdTask != null) {
            context.read<TaskListBloc>().add(TaskListTaskAdded(addedTask: createdTask));
          }
        },
        child: const Text('+'),
      ),
      body: SafeArea(
        child: BlocBuilder<TaskListBloc, TaskListState>(builder: (context, state) {
          if (state.status == TaskListStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == TaskListStatus.loaded) {
            if (state.taskList.isEmpty) {
              return const Center(
                child: Text('No Tasks found'),
              );
            } else {
              return ListView.builder(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  itemCount: state.taskList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        tileColor: Colors.blueGrey.withOpacity(0.2),
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        onTap: () async {
                          TaskModel? updatedTask = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailsPageView(task: state.taskList[index]),
                            ),
                          );
                          context.read<TaskListBloc>().add(TaskListFetch());
                        },
                        title: Text(state.taskList[index].taskTitle),
                        subtitle: Text(
                          state.taskList[index].taskDescription,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(state.taskList[index].taskStatus.split('.').last),
                      ),
                    );
                  });
            }
          } else {
            return const Center(
              child: Text('An error occurred'),
            );
          }
        }),
      ),
    );
  }
}
