import 'package:flutter/material.dart';
class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Account"),),
      body: Center(child: Text('Account')),
    );
  }
}