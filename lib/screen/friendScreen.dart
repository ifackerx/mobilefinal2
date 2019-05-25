import 'package:flutter/material.dart';
import 'package:flutter_prepared/screen/todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class FriendScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FriendScreenState();
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var user = User.fromJson(body[i]);
      userApi.add(user);
    }
    return userApi;
  } else {
    throw Exception('Failed to load');
  }
}

class User {
  final int id;
  final String name, email, phone, website;

  User({this.id, this.name, this.email, this.phone, this.website});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}


class FriendScreenState extends State<FriendScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
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
              future: fetchUsers(),
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
    List<User> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            child: InkWell(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${(values[index].id).toString()} : ${values[index].name}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    values[index].email,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    values[index].phone,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    values[index].website,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoScreen(id: values[index].id),
                ),
              );
            },
            ),
          );
        },
      ),
    );
  }


}