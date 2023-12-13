import 'package:daily_expense_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class CategoryPage extends StatefulWidget {
  static const String routeName = '/category';
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void didChangeDependencies() {
    Provider.of<AppProvider>(context, listen: false).getAllCategories();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: const Text(
          'Category',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          showSingleTextFiledDialog(
              context: context,
              title: 'Category Add',
              hint: 'Enter category name',
              onSave: (value) {
                Provider.of<AppProvider>(context, listen: false)
                    .addCategory(value)
                    .then((id) {
                  showMsg(context, 'Category added');
                }).catchError((error) {
                  showMsg(context, 'Could not save');
                });
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) => ListView.builder(
          itemCount: provider.categoryList.length,
          itemBuilder: (context, index) {
            final category = provider.categoryList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal:10),
              child: Card(
                elevation: 3,
                child: ListTile(
                  leading: Text(category.id.toString()),
                  title: Text(category.name),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
