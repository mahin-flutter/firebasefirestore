import 'package:listapp/models/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {

  static Database? _db;

  Future<Database> get database async{
    _db??= await initDb();
    return _db!;
  }
  
  // initlize the database
  Future<Database> initDb() async{
    final path = join(await getDatabasesPath(), 'users.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db,version) async{
        await db.execute('''
CREATE TABLE users(
id TEXT PRIMARY KEY,
fname TEXT,
lname TEXT,
phonenumber TEXT,
district TEXT,
state TEXT,
country TEXT,
updatedAt INTEGER,
isSynced INTEGER,
isDeleted INTEGER
)
''');
      }
    );
  }

  // To insert or update user details
  Future<void> userInsertOrUpdate(UserModel user) async{
    final db = await database;
    await db.insert('users', user.toMap(),conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // to get user details
  Future<List<UserModel>> getUser() async{
    final db = await database;
    final res = await db.query('users',where: 'isDeleted = 0',orderBy: 'updatedAt DESC');
    return res.map((e) => UserModel.fromMap(e) ).toList();
  }

  // get user that are not synced to firebase
  Future<List<UserModel>> getUnsyncedUser() async{
    final db = await database;
    final res = await db.query('users', where: 'isSynced = 0 AND isDeleted = 0');
    return res.map((e) => UserModel.fromMap(e)).toList();
  }

  // to delete user details
  Future<void> deleteUser(String id) async{
    final db = await database;
    await db.update('users', {
      'isDeleted' : 1,
      'isSynced' : 0,
      'updatedAt' : DateTime.now().millisecondsSinceEpoch
    },
    where: 'id = ?',    
    whereArgs: [id]
   );
  }
}