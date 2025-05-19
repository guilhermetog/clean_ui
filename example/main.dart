import 'package:clean_ui/src/clean_ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends UIComponent with UIState {
  final String title;
  int _counter = 0;

  MyHomePage({required this.title});

  void _incrementCounter() {
    _counter++;
    render();
  }

  @override
  Widget buildChild(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: UIText()..text = title,
      ),
      body:
          UIColumn()
            ..mainAxisAlignment = MainAxisAlignment.center
            ..children = [
              UIText()..text = 'You have pushed the button this many times:',
              UIText()
                ..text = '$_counter'
                ..style = Theme.of(context).textTheme.headlineMedium,
            ],
      floatingActionButton:
          UIcon()
            ..padding = EdgeInsets.all(pHeight(10))
            ..color = Theme.of(context).colorScheme.primary
            ..onTap.then(_incrementCounter)
            ..icon = Icons.add
            ..iconColor = Colors.white,
    );
  }
}
