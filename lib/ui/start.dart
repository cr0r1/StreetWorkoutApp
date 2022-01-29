import 'package:flutter/material.dart';
import './size_helper.dart';
import 'buttons_rep.dart';

class StartScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  const StartScreen({Key? key, required this.data}) : super(key: key);
  final int test = 3;
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> _keys = widget.data.keys.toList();
    List<String> _exercices = _parse(_keys);
    List<int> _rep = List.generate(_exercices.length, (index) => 2);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent.withOpacity(0.3),
      body: ButtonsRep(
        data: widget.data,
        exercices: _exercices,
        rep: _rep,
      ),
    );
  }

  List<String> _parse(List keys) {
    List<String> tmp = [];
    int i = 0;
    while (i < keys.length) {
      if (widget.data[keys[i]] == true) {
        tmp.add(keys[i]);
      }
      i++;
    }
    return tmp;
  }
}
