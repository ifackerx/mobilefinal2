import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

Future<List<Todo>> fetchTodos(int userid) async {
  final response = await http.get('https://jsonplaceholder.typicode.com/todos?userID=${userid}');

  List<Todo> todoApi = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var todo = Todo.fromJson(body[i]);
      if(todo.userid == userid){
        todoApi.add(todo);
      }
    }
    return todoApi;
  } else {
    throw Exception('Failed to load post');
  }
}

class Todo {
  final int userid, id;
  final String title, completed;

  Todo({this.userid, this.id, this.title, this.completed});

  factory Todo.fromJson(Map<String, dynamic> json) {
      return Todo(
      userid: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: (json['completed'] ? "complete" : ""),
    );
  }
}

class TodoScreen extends StatelessWidget {
  final int id;
  TodoScreen({Key key, @required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("todo"),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            RaisedButton(
      
              child: Text("BACK"),
              
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),

            FutureBuilder(
              future: fetchTodos(this.id),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return new Text('loading...');
                  default:
                    if (snapshot.hasError){
                      return new Text('Error: ${snapshot.error}');
                    } else {
                      return createListView(context, snapshot);
                    }
                }
              },
            ),
            
          ],
        ),
      ),
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Todo> data = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: InkWell(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    (data[index].id).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[index].title,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data[index].completed,
                  ),
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }

}