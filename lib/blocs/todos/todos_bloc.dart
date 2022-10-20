import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo/models/todo_model.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc() : super(TodosLoading()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  void _onLoadTodos(LoadTodos event , Emitter emit) async {
    emit(
      TodosLoaded(todos: event.todos)
    );
  }

  void _onAddTodo(AddTodo event , Emitter emit) async {
    final state = this.state ;
    // await Future.delayed(const Duration(seconds: 2)) ;
    if(state is TodosLoaded){
      emit(
        TodosLoaded(
          todos: List.from(state.todos)..add(event.todo)
        )
      );
    }
  }

  void _onUpdateTodo(UpdateTodo event , Emitter emit) {
    final state = this.state ;
    if(state is TodosLoaded){
      List<Todo> todos = state.todos.map((todo) => todo.id == event.todo.id ? event.todo : todo).toList() ;
      emit(
          TodosLoaded(
              todos: todos
          )
      );
    }
  }

  void _onDeleteTodo(DeleteTodo event , Emitter emit) {
    final state = this.state ;
    if(state is TodosLoaded){
      List<Todo> todos = state.todos.where((todo) => todo.id != event.todo.id ).toList() ;
      emit(
          TodosLoaded(
              todos: todos
          )
      );
    }
  }

}
