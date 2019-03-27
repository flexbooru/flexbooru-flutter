import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
        ),
      body: Center(child: Text('Settings')),
    );
  }
}