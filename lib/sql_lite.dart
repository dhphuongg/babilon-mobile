import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CacheDatabase {
  static Database? _database;

  // Mở database, tạo bảng nếu chưa có
  static Future<Database> get database async {
    if (_database != null) return _database!;

    final directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cache.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE Cache (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            url TEXT,
            response TEXT
          )
        ''');
      },
    );

    return _database!;
  }

  // Hàm lưu response vào cache
  static Future<void> saveResponse(String url, String response) async {
    final db = await database;

    // Kiểm tra nếu URL đã tồn tại, thì cập nhật
    var res = await db.query("Cache", where: "url = ?", whereArgs: [url]);
    if (res.isNotEmpty) {
      // Update
      await db.update("Cache", {'response': response},
          where: "url = ?", whereArgs: [url]);
    } else {
      // Insert
      await db.insert("Cache", {'url': url, 'response': response});
    }
  }

  // Hàm load response từ cache dựa trên URL
  static Future<String?> loadResponse(String url) async {
    final db = await database;

    var res = await db.query("Cache", where: "url = ?", whereArgs: [url]);

    if (res.isNotEmpty) {
      return res.first['response'] as String?;
    }

    return null; // Không tìm thấy dữ liệu
  }

  // Xóa cache nếu cần thiết
  static Future<void> clearCacheDatabase() async {
    final db = await database;
    await db.delete("Cache");
  }
}
