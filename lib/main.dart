import 'package:daily_expense_app/pages/add_expense_page.dart';
import 'package:daily_expense_app/pages/category_page.dart';
import 'package:daily_expense_app/pages/home_page.dart';
import 'package:daily_expense_app/providers/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => AppProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (_) => const HomePage(),
        AddExpensePage.routeName: (_) => const AddExpensePage(),
        CategoryPage.routeName: (_) => const CategoryPage(),
      },
    );
  }
}
