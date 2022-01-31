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
              height: MediaQuery.of(context).size.height * 0.80,
              decoration: const BoxDecoration(color: Colors.blueAccent),
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
                  child: Stack(
                    children: [
                      Text("GO", style: settingStyle()),
                    ],
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.20,
              decoration:
                  BoxDecoration(color: Colors.blueAccent.withOpacity(0.8)),
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Settings",
                    style: settingStyle(),
                  )),
            )
          ],
        ),
      ],
    ));
  }
}
