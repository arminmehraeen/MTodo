import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/todos/todos_bloc.dart';
import 'package:todo/models/todo_model.dart';

class AddTodoScreen extends StatelessWidget {
  const AddTodoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();
    TextEditingController controllerTask = TextEditingController();
    TextEditingController controllerDescription = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a To Do"),
      ),
      body: BlocListener<TodosBloc, TodosState>(
        listener: (context, state) {
          log(state.toString());
          if(state is TodosLoaded){
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Todo create successfully"))
            );
            Navigator.pop(context);
          }
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Form(
                    key: _formKey,
                    child: Column(children: [
                  _inputField("Task", controllerTask),
                  _inputField("Description", controllerDescription),
                ],)) ,
                ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()){
                        var todo = Todo(
                            id: DateTime.now().toString() ,
                            task: controllerTask.value.text,
                            description: controllerDescription.value.text);

                        context.read<TodosBloc>().add(AddTodo(todo: todo));

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Theme
                          .of(context)
                          .primaryColor,
                    ),
                    child: const Text("Confirm"))
              ],
            ),
          ),
        ),
      ),
    );
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
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF000A1F)),
              ),
              errorStyle: const TextStyle(
                color: Color(0xFF000A1F),
              ),
              border: const OutlineInputBorder()
            ),
            controller: controller,
          ),
        )
      ],
    );
  }
}
