import 'dart:developer';
import 'package:banner_listtile/banner_listtile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:todo/blocs/todos/todos_bloc.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/add_todo_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: const Text("Todo App"),
    ),
    body: BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is TodosLoaded) {
          if (state.todos.isEmpty) {
            return const Center(
              child: Text(
                "Todos list is empty",
                style:
                TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ) ;
          }else {
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
        }
        else {
          return const Text("There is a Problem") ;
        }
      },
    ),
    floatingActionButton: FloatingActionButton(onPressed: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddTodoScreen(),
          ));
    },child: const Icon(Icons.add),),
      ) ;
  }

  Row _todoCard(BuildContext context, Todo todo) {
    return Row(
      children: [
        MSHCheckbox(
          size: 30,
          value: todo.isCompleted!,
          checkedColor: Theme.of(context).primaryColor,
          style: MSHCheckboxStyle.stroke,
          onChanged: (value) {
            context.read<TodosBloc>().add(UpdateTodo(todo: todo.copyWith(
                isCompleted: value
            ))) ;
          },
        ),
        const SizedBox(width: 5,) ,
        Flexible(child: BannerListTile(
          showBanner: todo.isCompleted!,
          bannerText: "Complete",
          bannersize: 45,
          onTap: (){
            print("Yes");
          },
          bannerTextColor: Colors.white,
          backgroundColor: Colors.white,
          elevation: 5,
          margin: const EdgeInsets.all(5).copyWith(bottom: 0),
          borderRadius: BorderRadius.circular(8),
          title: Text(
            todo.task,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
              decoration: todo.isCompleted ?? false ? TextDecoration.lineThrough : TextDecoration.none ,
            ),
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,) ,
            Text( todo.description.toString(),
                style: const TextStyle(fontSize: 13,)),
            Text( todo.dateTime.toString(),
                style: const TextStyle(fontSize: 13,)),
          ],
          ),
          bannerColor: Theme.of(context).primaryColor,
          trailing: IconButton(
              onPressed: () {
                context.read<TodosBloc>().add(DeleteTodo(todo: todo)) ;
                var snackBar =  SnackBar(content: Row(
                  children: const [
                    Icon(Icons.delete,color: Colors.grey, size: 18,) ,
                    SizedBox(width: 10,) ,
                    Text("Delete todo is successful")
                  ],
                )) ;
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              icon: const Icon(
                Icons.cancel,
                size: 18,
              )),
        ),)
      ],
    ) ;
  }
}
