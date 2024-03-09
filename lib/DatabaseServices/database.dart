
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class ProductsServices {
  static final _databaseName = "invoices.db";
  static final _databaseVersion = 1;

  static final table = 'Myproducts';
  static final secondtable = 'Myoperation';


  ProductsServices._privateConstructor();
  static final ProductsServices instance = ProductsServices._privateConstructor();

  static Database? _database;
  static final columnId = '_id';
  static final columnProductName = 'product_name';
  static final columnSellPrice = 'Sell_price';
  static final columnBuyPrice = 'Buyprice';
  static final columnQuantity = 'quantity';
  static final columnSolded = "soldedProducts";
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }


  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      $columnId TEXT NOT NULL,
      $columnProductName TEXT NOT NULL,
      $columnSellPrice TEXT NOT NULL,
      $columnBuyPrice TEXT NOT NULL,
      $columnQuantity TEXT NOT NULL, 
      $columnSolded TEXT NOT NULL
    )
  ''');
  }

  Future<List<Map<String, dynamic>>> getDataSortedByQuantityDescending() async {
    final db = await database;
    return await db.query(table, orderBy: '$columnQuantity DESC');
  }

  Future<List<Map<String, dynamic>>> getDataSortedByQuantityAsc() async {
    final db = await database;
    return await db.query(table, orderBy: '$columnQuantity ASC');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;

    // Extract values from the row map
    String id = row[columnId];
    String productName = row[columnProductName];
    String sellPrice = row[columnSellPrice];
    String buyPrice = row[columnBuyPrice];

    // Perform the update operation
    return await db.update(
      table,
      row,
      where: '$columnId = ? AND $columnProductName = ? AND $columnSellPrice = ? AND $columnBuyPrice = ?',
      whereArgs: [id, productName, sellPrice, buyPrice],
    );
  }


  Future<int> remove(Map<String, dynamic> row) async {
    Database db = await instance.database;

    // Extract values from the row map
    String id = row[columnId];
    String productName = row[columnProductName];
    String sellPrice = row[columnSellPrice];
    String buyPrice = row[columnBuyPrice];

    // Perform the update operation
    return await db.delete(
      table,
      where: '$columnId = ? AND $columnProductName = ? AND $columnSellPrice = ? AND $columnBuyPrice = ?',
      whereArgs: [id, productName, sellPrice, buyPrice],
    );
  }


  Future<List<Map<String, Object?>>> get(String id) async {
    Database db = await instance.database;
    return await db.query(table, where: '$columnId = ?', whereArgs: [id]);
  }

}