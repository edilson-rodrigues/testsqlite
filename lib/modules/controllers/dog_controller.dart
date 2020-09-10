import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

import 'package:testsqlite/modules/model/dog_model.dart';

class SqliteController {
  static final SqliteController instance = SqliteController._();

  SqliteController._();

  Database db;
  //List<Dog> doguinhos;
  final doguinhos = ValueNotifier<List<Dog>>([]);

  Future<void> initSql() async {
    WidgetsFlutterBinding.ensureInitialized();
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'doggie_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE dogs(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)",
        );
      },
      version: 1,
    );

    //passando para a conn
    db = await database;

    //inset dog
    var fido = Dog(
      id: 0,
      name: 'Fido',
      age: 35,
    );
    // Insert a dog into the database.
    await insertDog(fido);
    doguinhos.value = await dogs();
  }

  Future<void> insertDog(Dog dog) async {
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> dogs() async {
    //get gogs
    final List<Map<String, dynamic>> maps = await db.query('dogs');

    return List.generate(maps.length, (i) {
      return Dog(
        id: maps[i]['id'],
        name: maps[i]['name'],
        age: maps[i]['age'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    await db.update(
      'dogs',
      dog.toMap(),
      where: "id = ?",
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    await db.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}
