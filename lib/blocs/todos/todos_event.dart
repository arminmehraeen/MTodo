part of 'todos_bloc.dart';

@immutable
abstract class TodosEvent {}

class LoadTodos extends TodosEvent {
  final List<Todo> todos ;
  LoadTodos({this.todos = const <Todo>[]}) ;
}

class AddTodo extends TodosEvent {
  final Todo todo ;
  AddTodo({required this.todo}) ;
}

class UpdateTodo extends TodosEvent {
  final Todo todo ;
  UpdateTodo({required this.todo}) ;
}

class DeleteTodo extends TodosEvent {
  final Todo todo ;
  DeleteTodo({required this.todo}) ;
}
