import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/model/tag_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';

class TagsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TagsPageState();
}

class TagsPageState extends State<TagsPage> {

  List<TagBase> _tags = [];

  @override
  void initState() {
    super.initState();
    _fechTagsList();
  }

  void _fechTagsList() async {
    String scheme = 'https';
    String host = 'danbooru.donmai.us';
    var params = <String, dynamic>{
      'limit': 30,
      'page': 1
    };
    var tags = await DanApi.instance.getTags(scheme, host, params);
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
