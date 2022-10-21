import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/todo_model.dart';

class StorageService {

  static const String _key = "todos" ;

  static Future write(List<Todo> todos) async{
    final prefs = await SharedPreferences.getInstance();

    List<String> list = [] ;
    for(Todo todo in todos) {
      list.add(jsonEncode(todo.toMap())) ;
    }
    await prefs.setStringList(_key, list );

  }

  static Future<List<Todo>> read() async{
    final prefs = await SharedPreferences.getInstance();
    List<String> source = prefs.getStringList(_key) ?? [] ;
    if (source.isNotEmpty) {
      return source.map((e) => Todo.fromMap(jsonDecode(e)) ).toList() ;
    }
    return [] ;
  }
}