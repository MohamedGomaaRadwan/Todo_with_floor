import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_floor/database/database.dart';
import 'package:todo_floor/models/todo.dart';

class AddTodo extends StatefulWidget {

  TextEditingController _textEditingController = new TextEditingController();

  @override
  State<StatefulWidget> createState() => _addTodoData();
}

class _addTodoData extends State<AddTodo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add TODO'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 100,
            margin: EdgeInsets.all(10),
            child: TextField(
              maxLines: 5,
              controller: widget._textEditingController,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey))),
              onTap: () {},
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed:()=> _saveCall(),
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }

  _saveCall() {
    final database = $FloorAppDatabase.databaseBuilder('tododatabase.db').build();
    database.then((onValu){
      onValu.todoDao.getMaxTodo().then((onValue){
        int id = 1;
        if(onValue != null){
          id=onValue.id+1;
        }
        onValu.todoDao.insertTodo(Todo(id,widget._textEditingController.value.text,DateFormat('dd-mm-yyyy kk:mm').format(DateTime.now()),""));
        setState(() {});
      });
    });
    Navigator.pop(context);
  }

}
