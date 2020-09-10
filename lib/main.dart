import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'modules/controllers/dog_controller.dart';
import 'modules/model/dog_model.dart';

void main() {
  runApp(APP());
}

class APP extends StatefulWidget {
  @override
  _APPState createState() => _APPState();
}

class _APPState extends State<APP> {
  SqliteController sqliteController = SqliteController.instance;

  @override
  void initState() {
    sqliteController.initSql();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Center(
            child: ValueListenableBuilder<List<Dog>>(
              valueListenable: sqliteController.doguinhos,
              builder: (context, dogs, child) => ListView.builder(
                itemCount: dogs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text('id: ${dogs[index].id}'),
                        Text('name: ${dogs[index].name}'),
                        Text('age: ${dogs[index].age}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
