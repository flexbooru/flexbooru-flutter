import 'package:flutter/material.dart';
class CommentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Comments"),),
      body: Center(child: Text('Comments')),
    );
  }
}