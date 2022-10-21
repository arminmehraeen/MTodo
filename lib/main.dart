import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/blocs/todos/todos_bloc.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/screens/home_screen.dart';
import 'package:todo/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodosBloc()..add(LoadTodos()) ,
      child: MaterialApp(
        title: 'MTodo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: "yekan",
          primarySwatch: Colors.blue,
          primaryColor: const Color(0xFF000A1F),
          appBarTheme: const AppBarTheme(
            color: Color(0xFF000A1F) ,
          )
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

