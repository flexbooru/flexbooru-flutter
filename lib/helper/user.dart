import 'package:flutter/foundation.dart';

class User extends Object {
  User({
    this.uid,
    @required this.booruUid,
    @required this.id,
    @required this.name,
    @required this.authKey
  });
  int uid = 0;
  int booruUid;
  int id;
  String name;
  String authKey;
}