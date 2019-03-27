import 'package:flutter/material.dart';
class BooruConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BooruConfigPageState();
}

class BooruConfigPageState extends State<BooruConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Booru config"),
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
        ),
      body: Center(child: Text('Booru config')),
    );
  }
}