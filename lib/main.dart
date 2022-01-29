import './ui/exercices.dart';
import 'package:flutter/material.dart';
import './ui/size_helper.dart';

void main() {
  runApp(const MaterialApp(
    home: NumberOfPlayer(),
  ));
}

class NumberOfPlayer extends StatefulWidget {
  const NumberOfPlayer({Key? key}) : super(key: key);

  @override
  _NumberOfPlayerState createState() => _NumberOfPlayerState();
}

class _NumberOfPlayerState extends State<NumberOfPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(color: Colors.blueGrey),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const ChooseExercices(
                          players: 1,
                        );
                      },
                    ));
                  },
                  child: Text(
                    "solo",
                    style: settingStyle(),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2,
              decoration: const BoxDecoration(color: Colors.blueAccent),
              child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) {
                        return const ChooseExercices(
                          players: 2,
                        );
                      },
                    ));
                  },
                  child: Text(
                    "Multi player",
                    style: settingStyle(),
                  )),
            )
          ],
        ),
      ],
    ));
  }
}
