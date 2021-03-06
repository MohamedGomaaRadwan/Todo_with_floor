
import 'package:floor/floor.dart';
import 'package:todo_floor/models/todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM todo')
  Future<List<Todo>> findAllTodo();

  @Query('SELECT * from todo order by id desc limit 1')
  Future<Todo?> getMaxTodo();

  @Query('SELECT * FROM todo order by id desc')
  Stream<List<Todo>> fetchStreamData();

  @insert
  Future<void> insertTodo(Todo todo);

  @insert
  Future<List<int>> insertAllTodo(List<Todo> todo);

  @Query("DELETE from todo where id = :id")
  Future<void> deleteTodo(int id);

  @delete
  Future<int> deleteAll(List<Todo> list);
}
