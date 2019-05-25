import 'package:flutter/material.dart';
import 'package:flutter_prepared/screen/friendScreen.dart';
import 'package:flutter_prepared/screen/home.dart';
import 'package:flutter_prepared/screen/loginScreen.dart';
import 'package:flutter_prepared/screen/profile.dart';
import 'package:flutter_prepared/screen/register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '60070030',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(          
           primaryColor: Colors.pink[100],
           accentColor: Colors.pink,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => LoginScreen(),
        "/home": (context) => HomeScreen(),
        "/profile": (context) => ProfileScreen(),
        "/friend": (context) => FriendScreen(),
        "/register": (context) => RegisterScreen(),

      },
    );
  }
}
