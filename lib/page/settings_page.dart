import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings"),),
      body: Center(child: Text('Settings')),
    );
  }
}