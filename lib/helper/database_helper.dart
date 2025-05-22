import 'dart:async';
import 'dart:developer';
import 'package:mindtech_task/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "UserDatabase.db";
  static final _databaseVersion = 2;
  static final table = 'users';
  static final columnId = 'id';
  static final columnName = 'name';
  static final columnEmail = 'email';
  static final columnMobileNumber = 'mobileNumber';
  static final columnDateOfBirth = 'dateOfBirth';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, _databaseName);
      log('Database path: $path');
      return await openDatabase(
        path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onOpen: (db) async {
          log('Database opened successfully');
          await db.execute('PRAGMA foreign_keys = ON');
        },
      );
    } catch (e) {
      log('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      log('Creating database table...');
      await db.execute('''
        CREATE TABLE $table (
          $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnName TEXT NOT NULL,
          $columnEmail TEXT NOT NULL,
          $columnMobileNumber TEXT NOT NULL,
          $columnDateOfBirth TEXT NOT NULL
        )
      ''');
      log('Database table created successfully');
    } catch (e) {
      log('Error creating database table: $e');
      rethrow;
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    log('Upgrading database from version $oldVersion to $newVersion');

    if (oldVersion < 2) {
      try {
        var columns = await db.rawQuery('PRAGMA table_info($table)');
        bool hasDateOfBirth =
            columns.any((column) => column['name'] == columnDateOfBirth);

        if (!hasDateOfBirth) {
          log('Adding dateOfBirth column...');
          await db.execute(
              'ALTER TABLE $table ADD COLUMN $columnDateOfBirth TEXT DEFAULT ""');
          log('dateOfBirth column added successfully');
        }
      } catch (e) {
        log('Error during database upgrade: $e');
        await db.execute('DROP TABLE IF EXISTS $table');
        await _onCreate(db, newVersion);
      }
    }
  }

  Future<int> insertUser(UserModel user) async {
    try {
      Database db = await database;
      log('Inserting user: ${user.toMap()}');
      int result = await db.insert(table, user.toMap());
      log('User inserted with ID: $result');
      return result;
    } catch (e) {
      log('Error inserting user: $e');
      rethrow;
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      Database db = await database;
      log('Fetching all users...');
      final List<Map<String, dynamic>> maps = await db.query(table);
      log('Found ${maps.length} users in database');

      List<UserModel> users = List.generate(maps.length, (i) {
        return UserModel.fromMap(maps[i]);
      });

      for (var user in users) {
        log('User: ${user.toString()}');
      }

      return users;
    } catch (e) {
      log('Error fetching users: $e');
      return [];
    }
  }

  Future<int> updateUser(UserModel user) async {
    try {
      Database db = await database;
      log('Updating user: ${user.toMap()}');
      int result = await db.update(
        table,
        user.toMap(),
        where: '$columnId = ?',
        whereArgs: [user.id],
      );
      log('User updated, affected rows: $result');
      return result;
    } catch (e) {
      log('Error updating user: $e');
      rethrow;
    }
  }

  Future<int> deleteUser(int id) async {
    try {
      Database db = await database;
      log('Deleting user with ID: $id');
      int result = await db.delete(
        table,
        where: '$columnId = ?',
        whereArgs: [id],
      );
      log('User deleted, affected rows: $result');
      return result;
    } catch (e) {
      log('Error deleting user: $e');
      rethrow;
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> getDatabaseInfo() async {
    try {
      Database db = await database;
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, _databaseName);

      log('-////////DATABASE INFO-\\\\\\\\\\');
      log('Database path: $path');
      log('Database version: ${await db.getVersion()}');

      var tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      log('Tables: $tables');

      if (tables.any((table) => table['name'] == table)) {
        var columns = await db.rawQuery('PRAGMA table_info($table)');
        log('Table columns: $columns');

        var count = await db.rawQuery('SELECT COUNT(*) as count FROM $table');
        log('Total records: ${count.first['count']}');
      }
      log('---------------------');
    } catch (e) {
      log('Error getting database info: $e');
    }
  }
}
