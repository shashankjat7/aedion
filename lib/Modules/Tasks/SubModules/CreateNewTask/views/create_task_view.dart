import 'package:aedion/Constants/route_names.dart';
import 'package:aedion/Modules/Tasks/SubModules/CreateNewTask/cubits/create_task_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTaskPageView extends StatelessWidget {
  static const routeName = RouteNames.createTaskViewRouteName;
  const CreateTaskPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CreateTaskCubit(),
      child: const CreateTaskView(),
    );
  }
}

class CreateTaskView extends StatelessWidget {
  const CreateTaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
      ),
      body: SafeArea(
        child: BlocListener<CreateTaskCubit, CreateTaskState>(
          listener: (context, state) {
            if (state.status == CreatedTaskStatus.postSuccess) {
              Navigator.pop(context, state.createdTask);
            }
          },
          child: ListView(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            children: const [
              _TitleInput(),
              SizedBox(
                height: 20,
              ),
              _DescriptionInput(),
              SizedBox(
                height: 60,
              ),
              _CreateTaskButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleInput extends StatelessWidget {
  const _TitleInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      buildWhen: (previous, current) => previous.title != current.title,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<CreateTaskCubit>().onTitleChanged(value);
          },
          decoration: InputDecoration(
            labelText: 'Title',
            errorText: state.isTitleValid() ? null : 'Enter a valid title',
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      buildWhen: (previous, current) => previous.description != current.description,
      builder: (context, state) {
        return TextField(
          onChanged: (value) {
            context.read<CreateTaskCubit>().onDescriptionChanged(value);
          },
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Description',
            errorText: state.isDescriptionValid() ? null : 'Enter a valid description',
          ),
        );
      },
    );
  }
}

class _CreateTaskButton extends StatelessWidget {
  const _CreateTaskButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateTaskCubit, CreateTaskState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status == CreatedTaskStatus.postingInProgress) {
          return ElevatedButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(10.0),
              child: SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          );
        } else {
          return ElevatedButton(
            onPressed: () {
              context.read<CreateTaskCubit>().onCreateButtonPressed();
            },
            child: const Text('Create Task'),
          );
        }
      },
    );
  }
}
