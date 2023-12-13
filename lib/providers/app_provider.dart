import 'package:daily_expense_app/db/db_helper.dart';
import 'package:daily_expense_app/models/category_model.dart';
import 'package:daily_expense_app/models/expense_model.dart';
import 'package:flutter/foundation.dart';

class AppProvider extends ChangeNotifier {
  List<CategoryModel> categoryList = [];
  List<ExpenseModel> expenseList = [];
  final db = DbHelper();
  Future<int> addCategory(String value) async {
    final category = CategoryModel(value);
    final id = await db.insertCategory(category);
    await getAllCategories();
    return id;
  }

  Future<int> addExpense(ExpenseModel expense) async {
    final id = await db.insertExpense(expense);
    await getAllExpense();
    return id;
  }

  Future<int> updateExpense(ExpenseModel expenseModel) async {
    final id = await db.updateExpense(expenseModel);
    await getAllExpense();
    return id;
  }

  Future<void> getAllCategories() async {
    categoryList = await db.getAllCategories();
    notifyListeners();
  }

  Future<void> getAllExpense() async {
    expenseList = await db.getAllExpense();
    notifyListeners();
  }

  Future<void> getAllExpenseByCategoryName(String name) async {
    expenseList = await db.getAllExpenseByCategoryName(name);
    notifyListeners();
  }

  Future<void> getAllExpenseByDateTime(DateTime dt) async {
    expenseList = await db.getAllExpenseByDateTime(dt);
    notifyListeners();
  }

  Future<CategoryModel> getCategoryByName(String name) async {
    return db.getCategoryByName(name);
  }

  Future<int> deleteExpense(int id) async {
    final deletedRowId = await db.deleteExpenseById(id);
    await getAllExpense();
    return deletedRowId;
  }
}
