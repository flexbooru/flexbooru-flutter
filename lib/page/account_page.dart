import 'package:flutter/material.dart';
class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
        ),
      body: Center(child: Text('Account')),
    );
  }
}