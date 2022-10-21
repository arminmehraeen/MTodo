import 'dart:developer';
import 'package:banner_listtile/banner_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roundcheckbox/roundcheckbox.dart';
import 'package:todo/blocs/todos/todos_bloc.dart';
import 'package:todo/models/todo_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => showModal(context), icon: const Icon(Icons.add))
        ],
        leading: const Icon(Icons.done),
        title: const Text("MTodo"),
      ),
      body: BlocBuilder<TodosBloc, TodosState>(
        builder: (context, state) {
          if (state is TodosLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is TodosLoaded) {
            if (state.todos.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        height: 200,
                        width: 200,
                        child: SvgPicture.asset("asset/empty.svg", )),
                    const SizedBox(height: 25,) ,
                    const Text(
                      "Todos list is empty",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.todos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _todoCard(context, state.todos[index]);
                      },
                    )
                  ],
                ),
              );
            }
          } else {
            return const Text("There is a Problem");
          }
        },
      ),
    );
  }

  void showModal(context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController controllerTask = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8))),
        builder: (context) {
          return BlocListener<TodosBloc, TodosState>(
            listener: (context, state) {
              log(state.toString());
              if (state is TodosLoaded) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Todo create successfully")));
                Navigator.pop(context);
              }
            },
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15 , horizontal:  15
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _inputField("Task", controllerTask),
                            _inputField("Description", controllerDescription),
                          ],
                        )),
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            var todo = Todo(
                                id: DateTime.now().toString(),
                                task: controllerTask.value.text,
                                description: controllerDescription.value.text);

                            context.read<TodosBloc>().add(AddTodo(todo: todo));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Theme.of(context).primaryColor,
                        ),
                        child: const Text("Confirm"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  Column _inputField(String field, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
                label: Text(
                  field,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF000A1F)),
                ),
                errorStyle: const TextStyle(
                  color: Color(0xFF000A1F),
                ),
                border: const OutlineInputBorder()),
            controller: controller,
          ),
        )
      ],
    );
  }

  Row _todoCard(BuildContext context, Todo todo) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: RoundCheckBox(
            onTap: (value) => context
                .read<TodosBloc>()
                .add(UpdateTodo(todo: todo.copyWith(isCompleted: value))),
            size: 30,
            isChecked: todo.isCompleted! ? true : false,
            checkedColor: Theme.of(context).primaryColor,
          ),
        ),
        Flexible(
          child: BannerListTile(
            showBanner: todo.isCompleted!,
            bannerText: "Complete",
            bannersize: 45,
            onTap: () {
              context
                  .read<TodosBloc>()
                  .add(UpdateTodo(todo: todo.copyWith(isCompleted: !todo.isCompleted!)));
            },
            bannerTextColor: Colors.white,
            backgroundColor: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.all(5),
            borderRadius: BorderRadius.circular(8),
            title: Text(
              todo.task,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
                decoration: todo.isCompleted ?? false
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(todo.description.toString(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13,
                    )),
                Text(todo.dateTime.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                    )),
              ],
            ),
            bannerColor: Theme.of(context).primaryColor,
            trailing: IconButton(
                onPressed: () {
                  context.read<TodosBloc>().add(DeleteTodo(todo: todo));
                  var snackBar = SnackBar(
                      content: Row(
                    children: const [
                      Icon(
                        Icons.delete,
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Delete todo is successful")
                    ],
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                icon: const Icon(
                  Icons.cancel,
                  size: 18,
                )),
          ),
        )
      ],
    );
  }
}
