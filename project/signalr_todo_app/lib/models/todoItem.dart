import 'package:flutter/foundation.dart';

class ToDoItem
{
  final int id;
  final String taskName;
  bool isDone = false;

  ToDoItem({
    required this.id,
    required this.taskName,
  });
}
