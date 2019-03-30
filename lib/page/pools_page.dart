import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flexbooru/model/pool_base.dart';
import 'package:flexbooru/network/api/danbooru.dart';
import 'package:flexbooru/network/api/danbooru_one.dart';
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
  int _page = 1;
  int _limit = 20;
  int _lastResponseSize = 0;
  LoadingStatus _loadingStatus = LoadingStatus.idle;
  ScrollController _scrollController =ScrollController();

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

  Future<int> _fechPoolsList() async {
    List<PoolBase> pools = [];
    var params = <String, dynamic>{
      'limit': _limit,
      'page': _page,
    };
    if (_booru.type == BooruType.danbooru) {
      pools = await DanApi.instance.getPools(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.moebooru) {
      pools = await MoeApi.instance.getPools(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.danbooru_one) {
      pools = await DanOneApi.instance.getPools(_booru.scheme, _booru.host, params);
    }
    if (pools == null) {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });
      _lastResponseSize = 0;
      if (_page == 1) {
        setState(() {
          _pools = [];
        });
      }
    } else {
      _loadingStatus = LoadingStatus.idle;
      _lastResponseSize = pools.length;
      if (_page != 1) {
        if(pools.isNotEmpty) {
          setState(() {
            _pools.addAll(pools);
          });
        }
      } else {
        setState(() {
          _pools = pools;
        });
      }
    }
    return _lastResponseSize;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RefreshIndicator(
        child: Scrollbar(
          child: Column(
            children: <Widget>[
              Flexible(
                child: ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  children: _pools.map<Widget>((PoolBase pool) {
                    return Column(
                      children: <Widget>[
                        ListTile(
                          isThreeLine: false,
                          dense: false,
                          leading: _buildAvatar(pool),
                          title: Text(pool.getPoolName()),
                        ),
                        Divider(height: 1.0),
                      ],
                    );
                  }).toList(),
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
        onRefresh: refreshData,
      ),
    );
  }

  Widget _buildFooter() {
    if (_loadingStatus == LoadingStatus.loading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (_loadingStatus == LoadingStatus.failed) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: RaisedButton(
            child: Text('Retry'),
            onPressed: () {
              _fechPoolsList();
              setState(() {
                _loadingStatus = LoadingStatus.loading;
              });
            },
          ),
        ),
      );
    }
    return Center();
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

  @override
  LoadingStatus getLoadingStatus() => _loadingStatus;

  @override
  ScrollController getScrollController() => _scrollController;

  @override
  void loadMoreData() {
    setState(() {
      _loadingStatus = LoadingStatus.loading;
    });
    _page += 1;
    _fechPoolsList();
  }

  @override
  Future<void> refreshData() async {
    setState(() {
      _loadingStatus = LoadingStatus.refreshing;
    });
    _page = 1;
    await _fechPoolsList();
  }
}
