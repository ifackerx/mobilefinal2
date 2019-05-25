import 'package:flutter/material.dart';
import '../utils/currentUser.dart';
import 'package:flutter_prepared/db/database.dart';


class ProfileScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen>{
  final _formkey = GlobalKey<FormState>();

  UserUtils user = UserUtils();
  final userid = TextEditingController(text: CurrentUser.USERID);
  final name = TextEditingController(text: CurrentUser.NAME);
  final age = TextEditingController(text: CurrentUser.AGE);
  final password = TextEditingController();
  final quote = TextEditingController(text: CurrentUser.QUOTE);

  bool userTaken = false;

  bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

 int spaceBar(String string){
    int count = 0;
    for(int i = 0;i < string.length;i++){
      if(string[i] == ' '){
        count += 1;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 15, 30, 0),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                labelText: "User Id",
              ),
              controller: userid,
              keyboardType: TextInputType.text,
              validator: (value) {
                
                if (value.isEmpty) {
                return "Please fill out this form";
                }
                else if (userTaken){
                  return "Username ถูกใช้แล้ว";
                }
                else if (value.length < 6 || value.length > 12){
                  return "User id ต้องมีความยาว 6-12 ตัวอักษร";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Name",
              ),
              controller: name,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if(spaceBar(value) != 1){
                  return "รูปแบบไม่ถูกต้อง";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Age",
              ),
              controller: age,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if (!isNumeric(value) || int.parse(value) < 10 || int.parse(value) > 80) {
                  return "รูปแบบไม่ถูกต้อง";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Password",
              ),
              controller: password,
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty || value.length <= 6) {
                  return "รูปแบบไม่ถูกต้อง";
                }
              }
            ),
            TextFormField(
              decoration: InputDecoration(
                labelText: "Quote",
              ),
              controller: quote,
              keyboardType: TextInputType.text,
              maxLines: 5
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
            RaisedButton(
              child: Text("SAVE"),
              onPressed: () async {
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();
                User userData = User();
                userData.id = CurrentUser.ID;
                userData.userid = userid.text;
                userData.name = name.text;
                userData.age = age.text;
                userData.password = password.text;
                userData.quote = quote.text;
                //function to check if user in
                Future isUserTaken(User user) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length;i++){
                    if (user.userid == userList[i].userid && CurrentUser.ID != userList[i].id){
                      this.userTaken = true;
                      break;
                    }
                  }
                }
                if (_formkey.currentState.validate()){
                  await isUserTaken(userData);
                  if(!this.userTaken) {
                    await user.updateUser(userData);
                    CurrentUser.USERID = userData.userid;
                    CurrentUser.NAME = userData.name;
                    CurrentUser.AGE = userData.age;
                    CurrentUser.PASSWORD = userData.password;
                    CurrentUser.QUOTE = userData.quote;
                    Navigator.pop(context);
                  }
                }
                this.userTaken = false;
  
              }
            ),
          ]
        ),
      )
    );
  }

}