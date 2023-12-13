import 'package:daily_expense_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../custom_widgets/main_drawer.dart';
import '../models/category_model.dart';
import '../providers/app_provider.dart';
import 'add_expense_page.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CategoryModel? categoryModel;
  DateTime? selectedDate;
  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllExpense();
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  _selectDate();
                },
                icon: const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                )),
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                            child: Text(category.name),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      categoryModel = value;
                    });
                    if (categoryModel!.name == 'All') {
                      provider.getAllExpense();
                    } else {
                      provider.getAllExpenseByCategoryName(categoryModel!.name);
                    }
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
            Expanded(
              child: ListView.builder(
                itemCount: provider.expenseList.length,
                itemBuilder: (context, index) {
                  final expense = provider.expenseList[index];
                  return Dismissible(
                    key: ValueKey(expense.id),
                    direction: DismissDirection.endToStart,
                    background: Card(
                      child: Container(
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.grey,
                        alignment: Alignment.centerRight,
                        child: const Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Delete Expense '),
                                content: Text(
                                    'Are you sure to delete item ${expense.name}?'),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('NO')),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                      child: const Text('YES')),
                                ],
                              ));
                    },
                    onDismissed: (direction) async {
                      await provider.deleteExpense(expense.id!);
                      showMsg(context, 'Deleted');
                    },
                    child: Card(
                      child: ListTile(
                        leading: IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AddExpensePage.routeName,
                                  arguments: expense);
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.indigo.shade400,
                            )),
                        title: Text(expense.name),
                        subtitle: Text(expense.formattedDate),
                        trailing: Text(
                          'BDT ${expense.amount}',
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 65,
        height: 65,
        margin: const EdgeInsets.only(right:153),
        child: FloatingActionButton(
          backgroundColor: Colors.indigo,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onPressed: () =>
              Navigator.pushNamed(context, AddExpensePage.routeName),
          child: const Text(
            'ADD',
            style: TextStyle(
              color: Colors.white,
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
      Provider.of<AppProvider>(context,listen: false).getAllExpenseByDateTime(selectedDate!);
    }
  }
}
