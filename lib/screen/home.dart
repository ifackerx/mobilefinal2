import 'package:flutter/material.dart';
import '../utils/currentUser.dart';


class HomeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home")
      ),
      
      body: Container(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          children: <Widget>[
            ListTile(
              title: Text('Hello ${CurrentUser.NAME}'),
              subtitle: Text('this is my quote "${CurrentUser.QUOTE != null ? CurrentUser.QUOTE == '' ? '-' : CurrentUser.QUOTE : ''}"'),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.of(context).pushNamed('/profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.of(context).pushNamed('/friend');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                CurrentUser.USERID = null;
                CurrentUser.NAME = null;
                CurrentUser.AGE = null;
                CurrentUser.PASSWORD = null;
                CurrentUser.QUOTE = null;
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
    );
  }

}