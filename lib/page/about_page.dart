import 'package:flutter/material.dart';
class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        backgroundColor: Colors.grey[50],
        ),
      body: Center(child: Text('About')),
    );
  }
}