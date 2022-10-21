import 'package:equatable/equatable.dart';

class Todo extends Equatable{

  final String id;
  final String task;
  final String description;
  DateTime? dateTime ;
  bool? isCompleted;
  bool? isCancelled;

  Todo({
    required this.id,
    required this.task,
    required this.description,
    this.dateTime ,
    this.isCompleted,
    this.isCancelled,
  }){
    dateTime = DateTime.now() ;
    isCancelled = isCancelled ?? false;
    isCompleted = isCompleted ?? false;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Todo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          task == other.task &&
          dateTime == other.dateTime &&
          description == other.description &&
          isCompleted == other.isCompleted &&
          isCancelled == other.isCancelled);

  @override
  int get hashCode =>
      id.hashCode ^
      task.hashCode ^
      description.hashCode ^
      dateTime.hashCode ^
      isCompleted.hashCode ^
      isCancelled.hashCode;


  @override
  String toString() {
    return 'Todo{id: $id, task: $task, description: $description, dateTime: $dateTime, isCompleted: $isCompleted, isCancelled: $isCancelled}';
  }

  Todo copyWith({
    String? id,
    String? task,
    String? description,
    DateTime? dateTime,
    bool? isCompleted,
    bool? isCancelled,
  }) {
    return Todo(
      id: id ?? this.id,
      task: task ?? this.task,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      isCompleted: isCompleted ?? this.isCompleted,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'description': description,
      'dateTime': dateTime.toString() ,
      'isCompleted': isCompleted,
      'isCancelled': isCancelled,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      task: map['task'] as String,
      description: map['description'] as String,
      dateTime: DateTime.parse(map['dateTime'] as String),
      isCompleted: map['isCompleted'] as bool,
      isCancelled: map['isCancelled'] as bool,
    );
  }

  @override
  List<Object?> get props => [
    id,
    task,
    description,
    isCancelled,
    isCompleted
  ];

}