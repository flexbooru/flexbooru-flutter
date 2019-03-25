import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flexbooru_flutter/model/post_base.dart';
import 'package:flexbooru_flutter/model/post_dan.dart';
import 'package:flexbooru_flutter/model/post_moe.dart';
import 'package:flexbooru_flutter/helper/booru.dart';
import 'package:flexbooru_flutter/helper/user.dart';

class DatabaseHelper {

  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  factory DatabaseHelper() => instance;
  
  static Database _database;

  Future<Database> get database async {
    if(_database == null) {
      _database = await _initDatabase();
    }
    return _database;
  }

  Future<Database> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "Flexbooru.db");
    Database database = await openDatabase(path, version: 1, onCreate: _onCreate);
    return database;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS `boorus` (`uid` INTEGER PRIMARY KEY NOT NULL, `type` INTEGER NOT NULL, `name` TEXT NOT NULL, `scheme` TEXT NOT NULL, `host` TEXT NOT NULL, `hash_salt` TEXT NOT NULL)");
    await db.execute("CREATE UNIQUE INDEX `index_boorus_scheme_host` ON `boorus` (`scheme`, `host`)");
    await db.execute("CREATE TABLE IF NOT EXISTS `users` (`uid` INTEGER PRIMARY KEY NOT NULL, `booru_uid` INTEGER NOT NULL, `id` INTEGER NOT NULL, `name` TEXT NOT NULL, `auth_key` TEXT, FOREIGN KEY(`booru_uid`) REFERENCES `boorus`(`uid`) ON UPDATE NO ACTION ON DELETE CASCADE )");
    await db.execute("CREATE UNIQUE INDEX `index_users_booru_uid` ON `users` (`booru_uid`)");
    await db.execute("CREATE TABLE IF NOT EXISTS `posts` (`uid` INTEGER PRIMARY KEY NOT NULL, `type` INTEGER NOT NULL, `post_id` INTEGER NOT NULL, `scheme` TEXT NOT NULL, `host` TEXT NOT NULL, `keyword` TEXT NOT NULL, `post` TEXT NOT NULL)");
    await db.execute("CREATE UNIQUE INDEX `index_posts_type_id_host_keyword` ON `posts` (`type`, `post_id`, `host`, `keyword`)");
  }

  void insertPosts(List<PostBase> posts) async {
    if (posts == null || posts.isEmpty) return;
    try {
      posts.forEach((post) {
        insertPost(post);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<int> insertPost(PostBase post) async {
    Database db = await database;
    var result = await db.insert(
      'posts', 
      <String, dynamic> {
        'type': post.type,
        'post_id': post.postId,
        'scheme': post.scheme,
        'host': post.host,
        'keyword': post.keyword,
        'post': jsonEncode(post.toJson())},
      conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }

  Future<List<PostBase>> getPosts({
    @required BooruType type, 
    @required String host, 
    @required String keyword}) async {
    
    List<PostBase> posts = [];
    Database db = await database;
    int indexType = BooruHelper.index(type);
    var data = await db.query(
      'posts', 
      where: '`type` = ? AND `host` = ? AND `keyword` = ? ORDER BY `uid` ASC', 
      whereArgs: [indexType, host, keyword]);
    if (data == null || data.isEmpty) return posts;
    switch (type) {
      case BooruType.danbooru:
        data.forEach((item) {
          Map<String, dynamic> json = jsonDecode(item['post'] as String);
          var post = PostDan.fromJson(json);
          post.uid = item['uid'] as int;
          post.type = indexType;
          post.postId = item['post_id'] as int;
          post.scheme = item['scheme'] as String;
          post.host = item['host'] as String;
          post.keyword = item['keyword'] as String;
          posts.add(post);
        });
        break;
      case BooruType.moebooru:
        data.forEach((item) {
          Map<String, dynamic> json = jsonDecode(item['post'] as String);
          var post = PostMoe.fromJson(json);
          post.uid = item['uid'] as int;
          post.type = indexType;
          post.postId = item['post_id'] as int;
          post.scheme = item['scheme'] as String;
          post.host = item['host'] as String;
          post.keyword = item['keyword'] as String;
          posts.add(post);
        });
        break;
      default:
    }
    return posts;
  }

  Future<List<Booru>> getAllBoorus() async {
    List<Booru> boorus = [];
    Database db = await database;
    var data = await db.rawQuery('SELECT * FROM `boorus`');
    data?.forEach((item) {
      boorus.add(Booru(
        uid: item['uid'] as int,
        type : BooruHelper.type(item['type'] as int),
        name: item['name'] as String,
        scheme: item['scheme'] as String,
        host: item['host'] as String,
        hashSalt: item['hash_salt'] as String));
    });
    return boorus;
  }

  Future<int> insertBooru(Booru booru) async {
    Database db = await database;
    var result = await db.insert(
      'boorus',
      <String, dynamic> {
        'type': BooruHelper.index(booru.type),
        'name': booru.name,
        'scheme': booru.scheme,
        'host': booru.host,
        'hash_salt': booru.hashSalt },
      conflictAlgorithm: ConflictAlgorithm.replace );
    return result;
  }

  Future<int> updateBooru(Booru booru) async {
    Database db = await database;
    var result = await db.update(
      'boorus',
      <String, dynamic> {
        'uid': booru.uid,
        'type': BooruHelper.index(booru.type),
        'name': booru.name,
        'scheme': booru.scheme,
        'host': booru.host,
        'hash_salt': booru.hashSalt },
      conflictAlgorithm: ConflictAlgorithm.replace );
    return result;
  }

  Future<int> deleteBooruByUid(int uid) async {
    Database db = await database;
    var result = await db.delete(
      'boorus',
      where: 'uid = ?',
      whereArgs: [uid]);
    return result;
  }
}