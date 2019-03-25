import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/model/tag_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';
import 'package:flexbooru_flutter/helper/database.dart';
import 'package:flexbooru_flutter/helper/user.dart';
import 'package:flexbooru_flutter/helper/booru.dart';

class TagsPage extends StatefulWidget {
  TagsPage(this._booru);
  final Booru _booru;
  @override
  State<StatefulWidget> createState() => TagsPageState(_booru);
}

class TagsPageState extends State<TagsPage> {
  TagsPageState(this._booru);
  final Booru _booru;
  List<TagBase> _tags = [];

  @override
  void initState() {
    super.initState();
    if (_booru == null) return;
    _fechTagsList();
  }

  void _fechTagsList() async {
    List<TagBase> tags = [];
    var params = <String, dynamic>{
      'limit': 30,
      'page': 1
    };
    if (_booru.type == BooruType.danbooru) {
      tags = await DanApi.instance.getTags(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.moebooru) {
      tags = await MoeApi.instance.getTags(_booru.scheme, _booru.host, params);
    }
    setState(() {
      _tags = tags;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        children: _tags.map<Widget>((TagBase tag) {
          return MergeSemantics(
            child: ListTile(
              isThreeLine: false,
              dense: false,
              title: Text(tag.getTagName()),
            ),
          );
        }).toList(),
      ),
    );
  }
}
