import 'package:flutter/material.dart';

import '../screens/CategoriesScreen.dart';
import '../screens/HomeScreen.dart';

class TodoList extends StatelessWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      initialRoute: '/home',
      routes: {
        '/home' : (context) => const HomeScreen(),
        '/categories' : (context) => const CategoriesScreen(),
      },
    );
  }
}
