import 'package:flutter/material.dart';
import 'package:flutter_prepared/db/database.dart';
import 'package:toast/toast.dart';
import '../utils/currentUser.dart';


class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen>{
  final _formkey = GlobalKey<FormState>();
  UserUtils user = UserUtils();
  
  final ctrlUser = TextEditingController();
  final ctrlPassword = TextEditingController();
  
  bool status = false;
  int ckeckForm = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LOGIN', style: TextStyle(color: Colors.black,)),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top : 15.0),
              child: Image.asset(
                "img/logo.jpg",
                width: 150,
                height: 150,
              ),
            ),

            TextFormField(
              controller: ctrlUser,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person, size: 40),
                labelText: "UserId",
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isNotEmpty) {
                  this.ckeckForm += 1;
                }
              }
            ),
            TextFormField(
              controller: ctrlPassword,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, size: 40),
                labelText: "Password",
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isNotEmpty) {
                  this.ckeckForm += 1;
                }
              }
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("Login"),
              onPressed: () async {
                _formkey.currentState.validate();
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();

                Future isUserValid(String userid, String password) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (userid == userList[i].userid && password == userList[i].password){
                      CurrentUser.ID = userList[i].id;
                      CurrentUser.USERID = userList[i].userid;
                      CurrentUser.NAME = userList[i].name;
                      CurrentUser.AGE = userList[i].age;
                      CurrentUser.PASSWORD = userList[i].password;
                      CurrentUser.QUOTE = userList[i].quote;
                      this.status = true;
                      break;
                    }
                  }
                }
                if(this.ckeckForm != 2){
                  Toast.show("Please fill out this form", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  this.ckeckForm = 0;
                } else {
                  this.ckeckForm = 0;
                  await isUserValid(ctrlUser.text, ctrlPassword.text);
                  
                  if( !this.status){
                    Toast.show("Invalid user or password", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                    ctrlUser.text = "";
                    ctrlPassword.text = "";
                  }
                }
              },
            ),
            FlatButton(
              child: Text("Register new user", textAlign: TextAlign.right),
              onPressed: () {
                Navigator.of(context).pushNamed('/register');
              },
              padding: EdgeInsets.only(left: 180.0),
            ),
          ],
        ),
      ),
    );
  }
}