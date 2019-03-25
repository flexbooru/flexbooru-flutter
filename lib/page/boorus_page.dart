import 'package:flutter/material.dart';
class BoorusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoorusPageState();
}

class BoorusPageState extends State<BoorusPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage boorus"),),
      body: Center(child: Text('Boorus')),
    );
  }
}