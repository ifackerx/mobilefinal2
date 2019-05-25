import 'package:flutter/material.dart';
import 'package:flutter_prepared/db/database.dart';


class RegisterScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return RegisterScreenState();
  }

}

class RegisterScreenState extends State<RegisterScreen>{
  final _formkey = GlobalKey<FormState>();

  UserUtils user = UserUtils();
  final ctrlUser = TextEditingController();
  final ctrlName = TextEditingController();
  final ctrlAge = TextEditingController();
  final ctrlPassword = TextEditingController();
  final ctrlQuote = TextEditingController();

  bool userTaken = false;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextFormField(
             
              controller: ctrlUser,
              
              keyboardType: TextInputType.text,
               decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_box),

                labelText: "User Id",
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                else if (value.length < 6 || value.length > 12){
                  return "User id ต้องมีความยาว 6-12 ตัวอักษร";
                }
                else if (this.userTaken){
                  return "Username ถูกใช้แล้ว";
                }
              }
            ),
            TextFormField(
              
              controller: ctrlName,


              decoration: InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.account_circle),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value.isEmpty) {
                  return "Please fill out this form";
                }
                if(spaceBar(value) != 1){
                  return "รูปแบบไม่ถูกต้อง";
                }
              }
            ),
            TextFormField(
             
              controller: ctrlAge,
              keyboardType: TextInputType.number,
                decoration: InputDecoration(
                labelText: "Age",
                prefixIcon: Icon(Icons.calendar_today),
              ),

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
              
              controller: ctrlPassword,

              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon : Icon(Icons.lock),
              ),
              obscureText: true,
              keyboardType: TextInputType.text,
              validator: (value) {
                // password มากว่า 6 แสดงว่าเป็น 6 ไม่ได้
                if (value.isEmpty || value.length <= 6) {
                  return 'Password มีความยาวมากว่า 6';
                }
              }
            ),
        
            RaisedButton(
              child: Text("REGISTER NEW ACCOUNT"),
              onPressed: () async {
                await user.open("user.db");
                Future<List<User>> allUser = user.getAllUser();
                User userData = User();
                  userData.userid = ctrlUser.text;
                  userData.name = ctrlName.text;
                  userData.age = ctrlAge.text;
                  userData.password = ctrlPassword.text;

                Future isNewUserIn(User user) async {
                  var userList = await allUser;
                  for(var i=0; i < userList.length; i++){
                    if (user.userid == userList[i].userid){
                      this.userTaken = true;
                      break;
                    }
                  }
                }

                await isNewUserIn(userData);

                if (_formkey.currentState.validate()){
                  if(await !this.userTaken) {
                    ctrlUser.text = "";
                    ctrlName.text = "";
                    ctrlAge.text = "";
                    ctrlPassword.text = "";
                    await user.insertUser(userData);
                    Navigator.pop(context);
                  }
                }

        
              }
              
            ),
          ],
        ),
      ),
    );
  }
                  bool isNumeric(String string) {
                  if(string == null) {
                    return false;
                  }
                  return double.parse(string, (e) => null) != null;
                }

                int spaceBar(String string){
                  int count = 0;
                  for(int i = 0; i < string.length; i++){
                    if(string[i] == ' '){
                      count += 1;
                    }
                  }
                  return count;
                }
}