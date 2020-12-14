import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cross_platform/data/database/word.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    initData();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'WordDB.db');
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute('CREATE TABLE Word ('
              'id INTEGER PRIMARY KEY,'
              'word TEXT,'
              'language TEXT'
              ')');
        });
  }

  initData() async {
    final testWords = <Word>[
      Word(word: 'PROGRAMMER', language: 'en'),
      Word(word: 'COMPUTER', language: 'en'),
      Word(word: 'TABLET', language: 'en'),
      Word(word: 'SYSTEM', language: 'en'),
      Word(word: 'APPLICATION', language: 'en'),
      Word(word: 'INTERNET', language: 'en'),
      Word(word: 'STYLUS', language: 'en'),
      Word(word: 'ANDROID', language: 'en'),
      Word(word: 'KEYBOARD', language: 'en'),
      Word(word: 'SMARTPHONE', language: 'en'),
      Word(word: 'ПРОГРАММИСТ', language: 'ru'),
      Word(word: 'КОМПЬЮТЕР', language: 'ru'),
      Word(word: 'ТАБЛИЦА', language: 'ru'),
      Word(word: 'СИСТЕМА', language: 'ru'),
      Word(word: 'ПРИЛОЖЕНИЕ', language: 'ru'),
      Word(word: 'ИНТЕРНЕТ', language: 'ru'),
      Word(word: 'СТИЛЬ', language: 'ru'),
      Word(word: 'АНДРОИД', language: 'ru'),
      Word(word: 'КЛАВИАТУРА', language: 'ru'),
      Word(word: 'СМАРТФОН', language: 'ru'),
    ];

    for(var i=0; i< testWords.length; i++){
      newWord(testWords[i]);
    }
  }

  newWord(Word newWord) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery('SELECT MAX(id)+1 as id FROM Word');
    int id = table.first['id'];
    //insert to the table using the new id
    final raw = await db.rawInsert(
        'INSERT Into Word (id,word,language)'
            ' VALUES (?,?,?)',
        [id, newWord.word, newWord.language]);
    return raw;
  }

  updateWord(Word newWord) async {
    final db = await database;
    final res = await db.update('Word', newWord.toMap(),
        where: 'id = ?', whereArgs: [newWord.id]);
    return res;
  }

  Future<List<Word>> getAllWords() async {
    final db = await database;
    final res = await db.query('Word');
    List<Word> list = res.isNotEmpty ? res.map((c) => Word.fromMap(c)).toList() : [];
    return list;
  }

  deleteWord(int id) async {
    final db = await database;
    return db.delete('Word', where: 'id = ?', whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete('Delete * from Word');
  }
}