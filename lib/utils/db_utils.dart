import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'teste1.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute('CREATE TABLE clients (' +
            'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'name TEXT, ' +
            'email TEXT, ' +
            'telephone TEXT, ' +
            'address TEXT, ' +
            'birthDate TEXT, ' +
            'startDate TEXT, ' +
            'photoFile TEXT, ' +
            'paymentFrequency INTEGER' +
            ')');

        db.execute('CREATE TABLE payments (' +
            'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'clientId INTEGER, ' +
            'expectedDate TEXT, ' +
            'effectiveDate TEXT, ' +
            'value REAL ' +
            ')');

        db.execute('CREATE TABLE IF NOT EXISTS checks (' +
            'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'clientId INTEGER, ' +
            'paymentId INTEGER, ' +
            'number TEXT, ' +
            'agreedDate TEXT, ' +
            'withdrawDate TEXT, ' +
            'value REAL ' +
            ')');

        db.execute('CREATE TABLE IF NOT EXISTS sessions (' +
            'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'clientId INTEGER, ' +
            'dateTime TEXT, ' +
            'effected INTEGER, ' +
            'paid INTEGER ' +
            'paymentId INTEGER ' +
            ')');

        return db.execute('CREATE TABLE sessiondays (' +
            'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
            'clientId INTEGER, ' +
            'day INTEGER, ' +
            'hour INTEGER ' +
            ')');
      },
    );
  }

  static Future<void> createTableClients() async {
    final db = await DbUtil.database();
    return db.execute('CREATE TABLE  IF NOT EXISTS clients (' +
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        'name TEXT, ' +
        'email TEXT, ' +
        'telephone TEXT, ' +
        'address TEXT, ' +
        'birthDate TEXT, ' +
        'startDate TEXT, ' +
        'photoFile TEXT, ' +
        'paymentFrequency INTEGER' +
        ')');
  }

  static Future<void> createTableSessionDays() async {
    final db = await DbUtil.database();
    return db.execute('CREATE TABLE IF NOT EXISTS sessiondays (' +
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        'clientId INTEGER, ' +
        'day INTEGER, ' +
        'hour INTEGER ' +
        ')');
  }

  static Future<void> createTablePayments() async {
    final db = await DbUtil.database();
    return db.execute('CREATE TABLE IF NOT EXISTS payments (' +
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        'clientId INTEGER, ' +
        'expectedDate TEXT, ' +
        'effectiveDate TEXT, ' +
        'value REAL ' +
        ')');
  }

  static Future<void> createTableChecks() async {
    final db = await DbUtil.database();
    return db.execute('CREATE TABLE IF NOT EXISTS checks (' +
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        'clientId INTEGER, ' +
        'paymentId INTEGER, ' +
        'number TEXT, ' +
        'agreedDate TEXT, ' +
        'withdrawDate TEXT, ' +
        'value REAL ' +
        ')');
  }

  static Future<void> createTableSessions() async {
    final db = await DbUtil.database();
    return db.execute('CREATE TABLE IF NOT EXISTS sessions (' +
        'id INTEGER PRIMARY KEY AUTOINCREMENT, ' +
        'clientId INTEGER, ' +
        'dateTime TEXT, ' +
        'effected INTEGER, ' +
        'paid INTEGER ' +
        'paymentId INTEGER ' +
        'idAuto INTEGER ' +
        ')');
  }

  static Future<void> alterTableClients() async {
    final db = await DbUtil.database();
    return db.execute('ALTER TABLE clients ADD paymentFrequency INTEGER');
  }

  static Future<void> alterTableSessions() async {
    final db = await DbUtil.database();
    return db.execute('ALTER TABLE sessions ADD idAuto INTEGER');
  }

  static Future<void> deleteTable(String table) async {
    final db = await DbUtil.database();
    return db.execute('DROP TABLE IF EXISTS $table');
  }

  static Future<sql.Database> getDB() async {
    return await DbUtil.database();
  }

  static Future<int> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    int id = await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.ignore,
    );
    return id;
  }

  static Future<void> update(
      String table, Map<String, Object> data, int id) async {
    final db = await DbUtil.database();
    await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> delete(String table, int id) async {
    final db = await DbUtil.database();
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> deleteByCondition(
      String table, String fieldName, dynamic value) async {
    final db = await DbUtil.database();
    await db.delete(table, where: '$fieldName = ?', whereArgs: [value]);
  }

  static Future<int> deleteByLessThan(
      String table, String fieldName, dynamic value) async {
    final db = await DbUtil.database();
    return await db.delete(table,
        where: "$fieldName IS NOT NULL AND $fieldName < '?'",
        whereArgs: [value]);
  }

  static Future<List<Map<String, dynamic>>> getDataByName(
      String table, String filter, String orderField) async {
    final db = await DbUtil.database();
    return db.query(table,
        where: 'name like ?', whereArgs: ['$filter%'], orderBy: orderField);
  }

  static Future<List<Map<String, dynamic>>> getAllData(
      String table, String orderField) async {
    final db = await DbUtil.database();
    return db.query(table, orderBy: orderField);
  }

  static Future<List<Map<String, dynamic>>> getDataByGenericField(
      String table, String searchField, String value, String orderField) async {
    final db = await DbUtil.database();
    return db.query(table,
        where: searchField, whereArgs: ['$value'], orderBy: orderField);
  }

  static Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    final db = await DbUtil.database();
    return await db.rawQuery(query);
  }

  static Future<int> rawDelete(String query) async {
    final db = await DbUtil.database();
    return await db.rawDelete(query);
  }
}
