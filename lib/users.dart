import 'package:flutter/material.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('USERS', style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        children: [
          
        ],
      ),
    );
  }
}
