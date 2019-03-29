import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flexbooru/model/tag_base.dart';
import 'package:flexbooru/network/api/danbooru.dart';
import 'package:flexbooru/network/api/moebooru.dart';
import 'package:flexbooru/helper/database.dart';
import 'package:flexbooru/helper/user.dart';
import 'package:flexbooru/helper/booru.dart';
import 'base_state.dart';

class TagsPage extends StatefulWidget {
  TagsPage(this._booru);
  final Booru _booru;
  @override
  State<StatefulWidget> createState() => TagsPageState(_booru);
}

class TagsPageState extends BaseState<TagsPage> {
  TagsPageState(this._booru);
  Booru _booru;
  List<TagBase> _tags = [];

  int _page = 1;
  int _limit = 20;
  int _lastResponseSize = 0;
  LoadingStatus _loadingStatus = LoadingStatus.idle;
  ScrollController _scrollController =ScrollController();

  @override
  void initState() {
    super.initState();
    if (_booru == null) return;
    _fechTagsList();
  }

  @override
  void onActiveBooruChanged(int uid) async {
    _booru = await DatabaseHelper.instance.getBooruByUid(uid);
    Timer.periodic(Duration(milliseconds: 250), (timer) {  
      timer.cancel();
      _fechTagsList();
    });
  }

  Future<int> _fechTagsList() async {
    List<TagBase> tags = [];
    var params = <String, dynamic>{
      'limit': _limit,
      'page': _page
    };
    if (_booru.type == BooruType.danbooru) {
      tags = await DanApi.instance.getTags(_booru.scheme, _booru.host, params);
    } else if (_booru.type == BooruType.moebooru) {
      tags = await MoeApi.instance.getTags(_booru.scheme, _booru.host, params);
    }
    if (tags == null) {
      setState(() {
        _loadingStatus = LoadingStatus.failed;
      });
      _lastResponseSize = 0;
      if (_page == 1) {
        setState(() {
          _tags = [];
        });
      }
    } else {
      _loadingStatus = LoadingStatus.idle;
      _lastResponseSize = tags.length;
      if (_page != 1) {
        setState(() {
          _tags.addAll(tags);
        });
      } else {
        setState(() {
          _tags = tags;
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
              _fechTagsList();
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
    _fechTagsList();
  }

  @override
  Future<void> refreshData() async {
    setState(() {
      _loadingStatus = LoadingStatus.refreshing;
    });
    _page = 1;
    await _fechTagsList();
  }
}
