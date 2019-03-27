import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/helper/booru.dart';
import 'package:flexbooru_flutter/helper/database.dart';

class BoorusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BoorusPageState();
}

class BoorusPageState extends State<BoorusPage> {
  Future<List<Booru>> _boorusFuture;
  @override
  void initState() {
    super.initState();
    _loadBoorus();
  }

  void _loadBoorus() {
    setState(() {
      _boorusFuture = DatabaseHelper.instance.getAllBoorus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage boorus"),
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.note_add),
            tooltip: 'Add booru',
            onPressed: () {

            },
          )
        ],),
      body: FutureBuilder<List<Booru>>(
        future: _boorusFuture,
        builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    default :
                      var data = snapshot.data;
                      if ( data == null || data.isEmpty) {
                        return Center(child: Text('none booru'));
                      } else {
                        return ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) => _buildTile(context, data[index]),
                        );
                      }
                  }
                },
      ),
    );
  }

  Widget _buildTile(BuildContext context, Booru booru) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: <Widget>[
              Text(
                booru.name,
                style: Theme.of(context).textTheme.title,
                ),
              Row(
                children: <Widget>[
                  IconButton(
                  alignment: Alignment.centerRight,
                  icon: const Icon(Icons.share),
                  tooltip: 'Share booru',
                  onPressed: () {

                  },
                ),
                IconButton(
                  alignment: Alignment.centerRight,
                  icon: const Icon(Icons.edit),
                  tooltip: 'Edit booru',
                  onPressed: () {

                  },
                ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, 
            children: <Widget>[
              Text(
                "${booru.scheme}://${booru.host}",
                style: Theme.of(context).textTheme.body1,
                ),
              Text(
                BooruHelper.name(booru.type),
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.right,
                )
            ],
          ),
        ),
      ],
    );
  }
}