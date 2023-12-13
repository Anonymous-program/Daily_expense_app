import 'package:daily_expense_app/pages/category_page.dart';
import 'package:daily_expense_app/pages/home_page.dart';
import 'package:flutter/material.dart';

import '../pages/add_expense_page.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.deepPurple,
          ),
          ListTile(
            title: const Text('Home'),
            leading: const Icon(Icons.home),
            onTap: () {
              Navigator.pushNamed(context, HomePage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.category_sharp),
            title: const Text(' Add Category'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, CategoryPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add Expense'),
            onTap: () {
              Navigator.pushNamed(context, AddExpensePage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
