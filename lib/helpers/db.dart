import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DB {
  static Future<sql.Database> dbConnection() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db
            .execute(
            'CREATE TABLE places(id TEXT PRIMARY KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)'
        );
      }, version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final connection = await dbConnection();
    await connection.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> query(String tableName) async {
    final connection = await dbConnection();
    return connection.query(tableName);
  }
}