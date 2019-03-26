import 'package:flutter/material.dart';
class BooruConfigPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BooruConfigPageState();
}

class BooruConfigPageState extends State<BooruConfigPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Booru config"),),
      body: Center(child: Text('Booru config')),
    );
  }
}