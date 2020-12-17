

import 'dart:convert';
// import 'package:news/src/resources/news_api_provider.dart';
import 'package:cross_platform/app.dart';
import 'package:cross_platform/data/database/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel('package:sqflite/sqflite.dart')
      .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'getAll') {
      return <String, dynamic>{};
    }
    return null;
  });
  // runApp(MyApp());
  DBProvider db;
  Database _database;
  group('db test', () {

    setUp(() async {

      db = await DBProvider.db;
      _database = await db.initDB();
      db.initData();
      db.deleteAll();
    });

    test('testPreConditions', () {
      expect(_database, null);
    });
  });
}
