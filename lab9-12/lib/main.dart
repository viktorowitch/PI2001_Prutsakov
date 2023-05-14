import 'package:flutter/material.dart';
import 'package:lab9/classes/Machine.dart';
import 'package:lab9/screens/addResourceScreen.dart';
import 'package:lab9/screens/makeCoffeeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Machine? machine;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Кофе-машина'),
            backgroundColor: Colors.brown,
            bottom: const TabBar(
              tabs: [
                Icon(Icons.coffee_maker),
                Icon(Icons.add),
              ],
            ),
          ),
          body: const TabBarView(
            children: [MakeCoffeeScreen(), AddResourceScreen()],
          ),
        ));
  }
}
