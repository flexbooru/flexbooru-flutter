import 'package:flutter/material.dart';
import 'package:flexbooru_flutter/model/pool_base.dart';
import 'package:flexbooru_flutter/network/api/danbooru.dart';
import 'package:flexbooru_flutter/network/api/moebooru.dart';
import 'package:flexbooru_flutter/helper/database.dart';
import 'package:flexbooru_flutter/helper/user.dart';
import 'package:flexbooru_flutter/helper/booru.dart';

class PoolsPage extends StatefulWidget {
  PoolsPage(this._booru);
  final Booru _booru;
  @override
  State<StatefulWidget> createState() => PoolsPageState(_booru);
}

class PoolsPageState extends State<PoolsPage> {
  PoolsPageState(this._booru);
  final Booru _booru;
  List<PoolBase> _pools = [];

  @override
  void initState() {
    super.initState();
    if (_booru == null) return;
    _fechPoolsList();
  }

  void _fechPoolsList() async {
    List<PoolBase> pools = [];
    var params = <String, dynamic>{
      'limit': 30,
      'page': 1
    };
    if (_booru.type == BooruType.danbooru) {
      pools = await DanApi.instance.getPools(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.moebooru) {
      pools = await MoeApi.instance.getPools(_booru.scheme, _booru.host, params);
    }
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
