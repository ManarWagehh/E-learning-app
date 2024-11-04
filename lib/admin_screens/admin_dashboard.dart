import 'package:flutter/material.dart';
import 'homestudent.dart';
import 'hometeacher.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            "Admin Dashboard",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const BackButtonIcon(),
          ),
        ),
        body: Column(children: [
          SizedBox(
            height: 220,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.indigo[600],
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text('Student',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ))),
              ),
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Hometeacher()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: Colors.indigo[600],
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text('Teacher',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ))),
              ),
            ),
          ),
        ]));
  }
}
