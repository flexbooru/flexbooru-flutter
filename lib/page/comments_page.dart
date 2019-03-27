import 'package:flutter/material.dart';
class CommentsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommentsPageState();
}

class CommentsPageState extends State<CommentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
        ),
      body: Center(child: Text('Comments')),
    );
  }
}