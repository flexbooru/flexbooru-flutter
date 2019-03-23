import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/model/pool_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';

class PoolsPage extends StatefulWidget {
  PoolsPage() : super();

  @override
  State<StatefulWidget> createState() => _PoolsPageList();
}

class _PoolsPageList extends State<PoolsPage> {

  List<PoolBase> _pools = [];

  @override
  void initState() {
    super.initState();
    _fechPoolsList();
  }

  void _fechPoolsList() async {
    String scheme = 'https';
    String host = 'danbooru.donmai.us';
    var params = <String, String>{
      'limit': '30',
      'page': '1'
    };
    var pools = await DanApi.instance.getPools(scheme, host, params);
    setState(() {
      _pools = pools;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        children: _pools.map<Widget>((PoolBase pool) {
          return MergeSemantics(
            child: ListTile(
              isThreeLine: false,
              dense: false,
              leading: ExcludeSemantics(child: CircleAvatar(child: Text(pool.getCreatorName()[0]))),
              title: Text(pool.getPoolName()),
            ),
          );
        }).toList(),
      ),
    );
  }
}
