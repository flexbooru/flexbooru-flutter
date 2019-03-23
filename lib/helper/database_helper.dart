import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flexbooru_flutter/model/post_base.dart';
import 'package:flexbooru_flutter/model/post_dan.dart';
import 'package:flexbooru_flutter/model/post_moe.dart';
import 'package:flexbooru_flutter/helper/booru_helper.dart';

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
    await db.execute("CREATE TABLE IF NOT EXISTS `posts` (`uid` INTEGER PRIMARY KEY NOT NULL, `type` INTEGER NOT NULL, `post_id` INTEGER NOT NULL, `scheme` TEXT NOT NULL, `host` TEXT NOT NULL, `keyword` TEXT NOT NULL, `post` TEXT NOT NULL)");
    await db.execute("CREATE UNIQUE INDEX `index_posts_type_id_host_keyword` ON `posts` (`type`, `post_id`, `host`, `keyword`)");
  }

  Future<Null> insetPosts(List<PostBase> posts) async {
    if (posts == null || posts.isEmpty) return null;
    try {
      posts.forEach((post) {
        insetPost(post);
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future<int> insetPost(PostBase post) async {
    Database db = await database;
    var result = await db.insert(
      'posts', 
      <String, dynamic> {
        'type': post.type,
        'post_id': post.postId,
        'scheme': post.scheme,
        'host': post.host,
        'keyword': post.keyword,
        'post': post.toJson().toString()},
      conflictAlgorithm: ConflictAlgorithm.replace);
    return result;
  }
}