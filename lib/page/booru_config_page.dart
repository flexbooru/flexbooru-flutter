import 'package:flutter/material.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:flexbooru/helper/database.dart';

class BooruConfigPage extends StatefulWidget {
  BooruConfigPage({this.booru});
  final Booru booru;
  @override
  State<StatefulWidget> createState() => BooruConfigPageState(booru);
}

class BooruConfigPageState extends State<BooruConfigPage> {
  BooruConfigPageState(this._booru);
  Booru _booru;
  int _uid = -1;
  String _name = '';
  String _scheme = 'https';
  BooruType _type = BooruType.danbooru;
  String _host = '';
  String _hashSalt = '';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _textEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_booru != null) {
      _uid = _booru.uid;
      _name = _booru.name;
      _scheme = _booru.scheme;
      _type = _booru.type;
      _host = _booru.host;
      _hashSalt = _booru.hashSalt;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _textEditController.dispose();
  }

  void _showInSnackBar(String msg) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Booru config"),
        backgroundColor: Colors.grey[50],
        elevation: 1.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () {
              if (_uid >= 0) {
                _deleteBooru(_uid);
              } else {
                Navigator.pop(context);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.done),
            tooltip: 'Apply',
            onPressed: () {
              if (_name.isEmpty) {
                _showInSnackBar('Booru name cant be empty.');
                return;
              }
              if (_host.isEmpty) {
                _showInSnackBar('Booru host cant be empty.');
                return;
              }
              if (_type == BooruType.moebooru || _type == BooruType.danbooru_one) {
                if (_hashSalt.isEmpty) {
                  _showInSnackBar('Booru hash salt cant be empty.');
                  return; 
                }
                if (!_hashSalt.contains('your-password')) {
                  _showInSnackBar('Booru hash salt must contains `your-password`.');
                  return; 
                }
              } else {
                _hashSalt = '';
              }
              if (_booru == null) {
                _booru = Booru(
                  type: _type,
                  name: _name,
                  scheme: _scheme,
                  host: _host,
                  hashSalt: _hashSalt,
                );
              } else {
                _booru.type = _type;
                _booru.name = _name;
                _booru.scheme = _scheme;
                _booru.host = _host;
                _booru.hashSalt = _hashSalt;
              }
              _saveBooru(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: _buildListItems(context)
      ),
    );
  }

  void _saveBooru(BuildContext context) async {
    int result = -1;
    if (_uid < 0) {
      result = await DatabaseHelper.instance.insertBooru(_booru);
    } else {
      result = await DatabaseHelper.instance.updateBooru(_booru);
    }
    if (result >= 0) {
      Navigator.pop(context, 'success'); 
    }
  }

  void _deleteBooru(int uid) async {
    int result = await DatabaseHelper.instance.deleteBooruByUid(_uid);
    if (result > 0) {
      Navigator.pop(context, 'success'); 
    }
  }

  List<Widget> _buildListItems(BuildContext context) {
    if (_type == BooruType.moebooru || _type == BooruType.danbooru_one) {
      return _buildAllListItems(context);
    } else return _buildBaseListItems(context);
  }

  List<Widget> _buildBaseListItems(BuildContext context) {
    var themeData = Theme.of(context);
    var catogoryStyle = themeData.textTheme.body2.copyWith(
      color: themeData.accentColor
    );
    List<Widget> items = <Widget>[
          // Name
          ListTile(
            leading: Icon(null),
            title: Text('Name'),
            subtitle: Text(_name),
            onTap: () {
              _textEditController.text = _name;
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Name'),
                  content: TextField(
                    maxLines: 1,
                    maxLength: 50,
                    controller: _textEditController,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        String value = _textEditController.text;
                        Navigator.pop(context, value);
                      },
                    )
                  ],
                ),
              ).then((String onValue) {
                if (onValue != null) {
                  setState(() {
                    _name = onValue;
                  });
                }
              });
            },
          ),
          Divider(height: 1.0,),
          ListTile(
            leading: Icon(null),
            title: Text(
              'Booru info',
              style: catogoryStyle,
            ),
          ),
          // Type
          PopupMenuButton<BooruType>(
            padding: EdgeInsets.zero,
            initialValue: _type,
            onSelected: (value) {
              setState(() {
                _type = value;
              });
            },
            child: ListTile(
              leading: Icon(Icons.book),
              title: Text('Type'),
              subtitle: Text(BooruHelper.name(_type)),
            ),
            itemBuilder: (context) => <PopupMenuItem<BooruType>> [
              PopupMenuItem<BooruType>(
                value:BooruType.danbooru,
                child: Text(BooruHelper.name(BooruType.danbooru)),
              ),
              PopupMenuItem<BooruType>(
                value:BooruType.moebooru,
                child: Text(BooruHelper.name(BooruType.moebooru)),
              ),
              PopupMenuItem<BooruType>(
                value:BooruType.danbooru_one,
                child: Text(BooruHelper.name(BooruType.danbooru_one)),
              ),
              PopupMenuItem<BooruType>(
                value:BooruType.gelbooru,
                child: Text(BooruHelper.name(BooruType.gelbooru)),
              ),
            ],
          ),
          // Scheme
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            initialValue: _scheme,
            onSelected: (value) {
              setState(() {
                _scheme = value;
              });
            },
            child:  ListTile(
              leading: Icon(Icons.https),
              title: Text('Scheme'),
              subtitle: Text(_scheme),
            ),
            itemBuilder: (context) => <PopupMenuItem<String>> [
              const PopupMenuItem<String>(
                value: 'https',
                child: Text('https'),
              ),
              const PopupMenuItem<String>(
                value: 'http',
                child: Text('http'),
              ),
            ],
          ),
          // Host
          ListTile(
            leading: Icon(Icons.domain),
            title: Text('Host'),
            subtitle: Text(_host),
            onTap: () {
              _textEditController.text = _host;
              showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Host'),
                  content: TextField(
                    maxLines: 1,
                    maxLength: 50,
                    controller: _textEditController,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        String value = _textEditController.text;
                        Navigator.pop(context, value);
                      },
                    )
                  ],
                ),
              ).then((String onValue) {
                if (onValue != null) {
                  setState(() {
                    _host = onValue;
                  });
                }
              });
            },
          ),
        ];
    return items;
  }

  List<Widget> _buildAllListItems(BuildContext context) {
    // Hash salt
    ListTile hashSaltItem = ListTile(
      leading: Icon(Icons.enhanced_encryption),
      title: Text('Hash salt'),
      subtitle: Text(_hashSalt),
      onTap: () {
        _textEditController.text = _hashSalt;
        showDialog<String>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Hash salt'),
            content: TextField(
              maxLines: 1,
              maxLength: 50,
              controller: _textEditController,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  String value = _textEditController.text;
                  Navigator.pop(context, value);
                },
              )
            ],
          ),
        ).then((String onValue) {
          if (onValue != null) {
            setState(() {
              _hashSalt = onValue;
            });
          }
        });
      },
    );
    var items = _buildBaseListItems(context);
    items.add(hashSaltItem);
    return items;  
  }
}