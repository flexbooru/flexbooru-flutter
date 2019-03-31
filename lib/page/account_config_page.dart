import 'package:flutter/material.dart';
class AccountConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountConfigPageState();
}

class AccountConfigPageState extends State<AccountConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account config"),
        elevation: 1.0,
        ),
      body: Center(child: Text('Account config')),
    );
  }
}