import 'package:daily_expense_app/models/category_model.dart';
import 'package:daily_expense_app/models/expense_model.dart';
import 'package:daily_expense_app/utils/helper_function.dart';
import 'package:daily_expense_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class AddExpensePage extends StatefulWidget {
  static const String routeName = '/add_expense';
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _fromKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  CategoryModel? categoryModel;
  ExpenseModel? expenseModel;
  DateTime selectedDate = DateTime.now();

  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null) {
      expenseModel = arg as ExpenseModel;
      _nameController.text = expenseModel!.name;
      _amountController.text = expenseModel!.amount.toString();
      selectedDate =
          DateTime.fromMicrosecondsSinceEpoch(expenseModel!.timestamp);
      _getCategory(expenseModel!.category);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text(
          expenseModel == null ? 'Add New Expense' : 'Update Expense',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Form(
          key: _fromKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      prefixIcon: Icon(Icons.drive_file_rename_outline),
                      hintText: 'Expense name',
                      filled: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please provide an expense name';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _amountController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.currency_exchange_sharp),
                        hintText: 'Expense Amount',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please provide an expense Amount';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
                  child: Card(
                    child: Consumer<AppProvider>(
                      builder: (context, provider, child) =>
                          DropdownButtonFormField<CategoryModel>(
                        iconSize: 30,
                        decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.category),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                        hint: const Text('Select category'),
                        value: categoryModel,
                        items: provider.categoryList
                            .map((category) => DropdownMenuItem<CategoryModel>(
                                  value: category,
                                  enabled:
                                      category.name == 'All' ? false : true,
                                  child: Text(
                                    category.name,
                                    style: TextStyle(
                                      color: category.name == 'All'
                                          ? Colors.grey
                                          : Colors.black,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            categoryModel = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.date_range),
                      label: const Text('Select Date'),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(getFormattedDate(selectedDate)),
                  ],
                ),
                if (expenseModel == null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SizedBox(
                      width: 100,
                      height: 55,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            elevation: 7,
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: _saveExpense,
                          child: const Text(
                            'SAVE',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
                if (expenseModel != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: SizedBox(
                      width: 100,
                      height: 55,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.grey,
                            elevation: 7,
                            backgroundColor: Colors.indigo,
                          ),
                          onPressed: _updateExpense,
                          child: const Text(
                            'UPDATE',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectDate() async {
    final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now().subtract(const Duration(days: 30)),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void _saveExpense() {
    if (_fromKey.currentState!.validate()) {
      final expense = ExpenseModel(
        name: _nameController.text,
        category: categoryModel!.name,
        amount: num.parse(_amountController.text),
        formattedDate: getFormattedDate(selectedDate),
        timestamp: selectedDate.microsecondsSinceEpoch,
        day: selectedDate.day,
        month: selectedDate.month,
        year: selectedDate.year,
      );
      Provider.of<AppProvider>(context, listen: false)
          .addExpense(expense)
          .then((value) {
        showMsg(context, 'Expense Saved');
        Navigator.pop(context);
      }).catchError((error) {
        showMsg(context, 'Failed to save');
      });
    }
  }

  void _updateExpense() async {
    if (_fromKey.currentState!.validate()) {
      expenseModel!.name = _nameController.text;
      expenseModel!.amount = num.parse(_amountController.text);
      expenseModel!.category = categoryModel!.name;
      expenseModel!.formattedDate = getFormattedDate((selectedDate));
      expenseModel!.timestamp = selectedDate.microsecondsSinceEpoch;
      expenseModel!.day = selectedDate.day;
      expenseModel!.month = selectedDate.month;
      expenseModel!.year = selectedDate.year;
      Provider.of<AppProvider>(context, listen: false)
          .updateExpense(expenseModel!)
          .then((value) {
        showMsg(context, 'Expense update');
        Navigator.pop(context);
      }).catchError((error) {
        showMsg(context, 'Failed to update');
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _getCategory(String name) async {
    categoryModel = await Provider.of<AppProvider>(context, listen: false)
        .getCategoryByName(expenseModel!.category);
    setState(() {});
  }
}
