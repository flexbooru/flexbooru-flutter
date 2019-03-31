import 'package:flutter/material.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:flexbooru/constants.dart';
import 'package:flexbooru/page/booru_config_page.dart';

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

  void _manulSettings(BuildContext context) async {
    var arg = await Navigator.of(context).pushNamed(ROUTE_BOORU_CONFIG);
    if (arg == 'success') {
      _loadBoorus();
    }
  }

  void _editBooru(BuildContext context, Booru booru) async {
    var arg = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => BooruConfigPage(booru: booru))
      );
    if (arg == 'success') {
      _loadBoorus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage boorus"),
        elevation: 1.0,
        actions: <Widget>[
          PopupMenuButton<int>(
            icon: const Icon(Icons.note_add),
            onSelected: (value) {
              switch (value) {
                case 0:
                  
                  break;
                case 1:

                  break;
                default:
                  _manulSettings(context);
              }
            },
            itemBuilder: (context) => <PopupMenuItem<int>> [
              const PopupMenuItem<int>(
                value: 0,
                child: Text('Scan QR code'),
              ),
              const PopupMenuItem<int>(
                value: 1,
                child: Text('Import from Clipboard'),
              ),
              const PopupMenuItem<int>(
                value: 2,
                child: Text('Manual settings'),
              ),
            ],
          ),
        ],
      ),
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
                    _editBooru(context, booru);
                  },
                ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 3.0),
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
        Divider(height: 1.0,),
      ],
    );
  }
}