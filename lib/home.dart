import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
          style: TextStyle(
            fontFamily: 'Times New Roman'
          ),
        ),
        backgroundColor: Color.fromARGB(255, 218, 179, 6),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[

        ],
      )
    );
  }
}