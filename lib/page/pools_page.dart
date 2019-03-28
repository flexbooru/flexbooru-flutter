import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flexbooru/model/pool_base.dart';
import 'package:flexbooru/network/api/danbooru.dart';
import 'package:flexbooru/network/api/moebooru.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:flexbooru/helper/user.dart';
import 'package:flexbooru/helper/booru.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'base_state.dart';

class PoolsPage extends StatefulWidget {
  PoolsPage(this._booru);
  final Booru _booru;
  @override
  State<StatefulWidget> createState() => PoolsPageState(_booru);
}

class PoolsPageState extends BaseState<PoolsPage> {
  PoolsPageState(this._booru);
  Booru _booru;
  List<PoolBase> _pools = [];

  @override
  void initState() {
    super.initState();
    if (_booru == null) return;
    _fechPoolsList();
  }

  @override
  void onActiveBooruChanged(int uid) async {
    _booru = await DatabaseHelper.instance.getBooruByUid(uid);
    Timer.periodic(Duration(milliseconds: 230), (timer) {  
      timer.cancel();
      _fechPoolsList();
    });
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
              leading: _buildAvatar(pool),
              title: Text(pool.getPoolName()),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAvatar(PoolBase pool) {
    if (_booru.type == BooruType.moebooru) {
      return ExcludeSemantics(
        child: CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(
            "${_booru.scheme}://${_booru.host}/data/avatars/${pool.getCreatorId()}.jpg"
          ),
        ),
      );
    } else {
      return ExcludeSemantics(
        child: CircleAvatar(
          child: Text(pool.getCreatorName()[0]),
        ),
      );
    }
  }
}
