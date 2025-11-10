import 'package:flutter/foundation.dart';
import 'package:simple_canvas/models/text_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();
  DatabaseHelper._init();

  static Database? _database;
  static const String _tableName = 'text_items';


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('canvas.db');
    return _database!;
  }


  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }


  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const doubleType = 'REAL NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $_tableName ( 
  ${TextItemFields.id} $idType, 
  ${TextItemFields.text} $textType,
  ${TextItemFields.positionDx} $doubleType,
  ${TextItemFields.positionDy} $doubleType,
  ${TextItemFields.fontSize} $doubleType,
  ${TextItemFields.fontFamily} $textType,
  ${TextItemFields.isBold} $boolType,
  ${TextItemFields.isItalic} $boolType,
  ${TextItemFields.isUnderline} $boolType,
  ${TextItemFields.colorValue} $intType
  )
''');
  }


  Future<List<TextItem>> getAllTextItems() async {
    final db = await instance.database;
    final maps = await db.query(_tableName);

    if (maps.isNotEmpty) {
      return maps.map((map) => TextItem.fromMap(map)).toList();
    } else {
      return [];
    }
  }


  Future<void> _clearTable() async {
    final db = await instance.database;
    await db.delete(_tableName);
  }


  Future<void> saveAllItems(List<TextItem> items) async {
    try {
      await _clearTable();
      final db = await instance.database;
      final batch = db.batch();

      for (var item in items) {
        batch.insert(_tableName, item.toMap());
      }

      await batch.commit(noResult: true);
    } catch (e) {
      debugPrint("Error saving all items: $e");
    }
  }


  Future close() async {
    final db = await instance.database;
    _database = null;
    db.close();
  }
}