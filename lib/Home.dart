import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _getDB() async {
    final dbRootPath = await getDatabasesPath();
    final dbPath = join(dbRootPath, "database.db");

    var db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, dbCurrentVersion) {
        String sql = "create table user (id integer primary key autoincrement, name varchar, age integer)";
        db.execute(sql);
      }
    );
    return db;
    //print("open: ${db.isOpen.toString()}");
  }

  _save() async {
    Database db = await _getDB();
    Map<String, dynamic> dataUser = {
      "name": "Carla Oliveira",
      "age": "35"
    };
    int id = await db.insert("user", dataUser);
    print("Saved: $id");
  }
  
  _listUsers() async {
    Database db = await _getDB();
    String sql = "select * from user where name = 'Marcelo Benedito'";
    List users = await db.rawQuery(sql);
    for (var user in users) {
      print(
        "item id: ${user["id"]}, "
        "name: ${user["name"]}, "
        "age: ${user["age"].toString()}, "
      );
    }
    //print("users: ${users.toString()}");
  }

  _getUserById(int id) async {
    Database db = await _getDB();
    List users = await db.query(
      "user",
      columns: ["id", "nome", "age"],
      where: "id = ?",
      whereArgs: [id]
    );

    for (var user in users) {
      print(
          "item id: ${user["id"]}, "
              "name: ${user["name"]}, "
              "age: ${user["age"].toString()}, "
      );
    }
  }

  _deleteUser(int id) async {
    Database db = await _getDB();
    int result = await db.delete(
      "user",
      where: "id = ?",
      whereArgs: [id]
    );
    print("deleted item quantity: ${result.toString()}");
  }

  _updateUser(int id) async {
    Database db = await _getDB();
    Map<String, dynamic> dataUser = {
      "name": "Carla Oliveira",
      "age": "32"
    };
    int result = await db.update(
        "user",
        dataUser,
        where: "id = ?",
        whereArgs: [id]
    );
    print("updated item quantity: ${result.toString()}");
  }

  @override
  Widget build(BuildContext context) {
   // _save();
    _listUsers();
    return Container();
  }
}
