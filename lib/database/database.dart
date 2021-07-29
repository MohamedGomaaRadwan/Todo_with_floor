
import 'dart:async';

import 'package:floor/floor.dart';
import 'package:todo_floor/dao/todo_dao.dart';
import 'package:todo_floor/models/todo.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1,entities: [Todo])
abstract class AppDatabase extends FloorDatabase {
  TodoDao get todoDao;
}
