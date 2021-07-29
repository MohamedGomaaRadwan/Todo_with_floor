import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_floor/dao/todo_dao.dart';
import 'package:todo_floor/database/database.dart';
import 'package:todo_floor/models/todo.dart';

import 'add_todo.dart';

class MyHomePage extends StatefulWidget {
  late final String title;
  MyHomePage({required this.title});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TodoDao _todoDao;
  List<Todo> todoList = [];
  final database = $FloorAppDatabase.databaseBuilder('tododatabase.db').build();

  _openAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodo()),
    );
  }

  @override
  void initState() {
    super.initState();
    database.then((onValueP) {
      setState(() {
        _todoDao = onValueP.todoDao;
      });
    });
    debugPrint('call in init');
  }

  Future<TodoDao> _callTheStream() async {
    AppDatabase appDatabase = await database;
    _todoDao = appDatabase.todoDao;
    return _todoDao;
  }

  void _selectedDelete(int id) {
    _todoDao.deleteTodo(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print debug
    // get dao
    debugPrint('build call');
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                List<Todo> listSelectedDat =
                    todoList.where((test) => test.isSelect == true).toList();
                _todoDao.deleteAll(listSelectedDat).then((onValue) {
                  debugPrint('deleted values :$onValue');
                  setState(() {});
                });
              },
            )
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<TodoDao>(
                    future: _callTheStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<TodoDao> snapshot) {
                      if (!snapshot.hasData ||
                          snapshot.connectionState == ConnectionState.none) {
                        return Container(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return StreamBuilder<List<Todo>>(
                            stream: snapshot.data!.fetchStreamData(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData ||
                                  snapshot.connectionState ==
                                      ConnectionState.none) {
                                return Container(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              else {
                                if (todoList.length != snapshot.data!.length) {
                                  todoList = snapshot.data!;
                                }
                                if (snapshot.data!.length == 0) {
                                  return Center(
                                    child: Text('No Data Found'),
                                  );
                                }
                                return Expanded(
                                  child: ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Card(
                                            child: ListTile(
                                          leading: Checkbox(
                                            value: todoList[index].isSelect,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                todoList[index].isSelect =
                                                    value!;
                                              });
                                            },
                                          ),
                                          trailing: GestureDetector(
                                            onTap: () {
                                              _selectedDelete(
                                                  snapshot.data![index].id);
                                            },
                                            child: Icon(Icons.delete),
                                          ),
                                          title: Text(
                                            '${snapshot.data![index].task}',
                                            maxLines: 1,
                                          ),
                                          subtitle: Text(
                                            '${snapshot.data![index].time}',
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ));
                                      }),
                                );
                              }
                            });
                      }
                    }),
              ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddScreen(),
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
