import 'package:daily_expense_app/models/category_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

import '../models/expense_model.dart';

class DbHelper {
  Future<Database> _open() async {
    const String createTableCategory = '''
    create table $tblCategory(
    $tblCategoryColId integer primary key autoincrement,
    $tblCategoryColName text )''';

    const String createTableExpense = '''create table $tblExpense(
    $tblExpenseColId integer primary key,
    $tblExpenseColName text,
    $tblExpenseColAmount integer,
    $tblExpenseColCategory text,
    $tblExpenseColFormattedDate text,
    $tblExpenseColTimestamp integer,
    $tblExpenseColDay integer,
    $tblExpenseColMonth integer,
    $tblExpenseColYear integer)''';

    final root = await getDatabasesPath();
    final dbPath = path.join(root, 'expense.db');
    return openDatabase(dbPath, version: 1, onCreate: (db, version) async {
      await db.execute(createTableCategory);
      await db.execute(createTableExpense);
    });
  }

  Future<int> insertCategory(CategoryModel categoryModel) async {
    final db = await _open();
    return db.insert(tblCategory, categoryModel.toMap());
  }

  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await _open();
    return db.insert(tblExpense, expense.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CategoryModel>> getAllCategories() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList =
        await db.query(tblCategory, orderBy: tblCategoryColName);
    return List.generate(
        mapList.length, (index) => CategoryModel.fromMap(mapList[index]));
  }

  Future<List<ExpenseModel>> getAllExpense() async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList =
        await db.query(tblExpense, orderBy: '$tblExpenseColTimestamp desc');
    return List.generate(
        mapList.length, (index) => ExpenseModel.fromMap(mapList[index]));
  }

  Future<List<ExpenseModel>> getAllExpenseByCategoryName(String name) async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(tblExpense,
        where: '$tblExpenseColCategory=?', whereArgs: [name],orderBy: '$tblExpenseColTimestamp desc');
    return List.generate(
        mapList.length, (index) => ExpenseModel.fromMap(mapList[index]));
  }

  Future<List<ExpenseModel>> getAllExpenseByDateTime(DateTime dt) async {
    final db = await _open();
    final List<Map<String, dynamic>> mapList = await db.query(tblExpense,
        where:
            '$tblExpenseColDay=? and $tblExpenseColMonth=? and $tblExpenseColYear=?',
        whereArgs: [dt.day, dt.month, dt.year],orderBy: '$tblExpenseColTimestamp desc');
    return List.generate(
        mapList.length, (index) => ExpenseModel.fromMap(mapList[index]));
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    final db = await _open();
    final mapList = await db
        .query(tblCategory, where: '$tblCategoryColName=?', whereArgs: [name]);
    return CategoryModel.fromMap(mapList.first);
  }

  Future<int> updateExpense(ExpenseModel expenseModel) async {
    final db = await _open();
    return db.update(tblExpense, expenseModel.toMap(),
        where: '$tblExpenseColId=?', whereArgs: [expenseModel.id]);
  }

  Future<int> deleteExpenseById(int id) async {
    final db = await _open();
    return db.delete(tblExpense, where: '$tblExpenseColId=?', whereArgs: [id]);
  }
}
