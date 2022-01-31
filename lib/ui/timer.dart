import 'package:flutter/material.dart';
import './size_helper.dart';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';

class Timerr extends StatefulWidget {
  final int breakTime;
  final int breakTimeSeconds;
  final int breakExercice;
  final int breakExerciceSeconds;
  final int numberOfSeries;
  final int timeForEx;
  final List<int> rep;
  final List<String> exercices;
  const Timerr({
    Key? key,
    required this.timeForEx,
    required this.exercices,
    required this.breakTime, // pause entre les series en min
    required this.breakTimeSeconds, // pause entre les series en sec
    required this.breakExercice, //pause entre les exos
    required this.breakExerciceSeconds, //pause entre les exos en sec
    required this.numberOfSeries, //nombre de series
    required this.rep,
  }) //minutes secondes de break exercices

  : super(key: key);

  @override
  _TimerrState createState() => _TimerrState();
}

class _TimerrState extends State<Timerr> {
  late int _breakEx =
      (widget.breakExerciceSeconds + (widget.breakExercice * 60)) == 0
          ? 60
          : widget.breakExerciceSeconds + (widget.breakExercice * 60);
  late int _breakSe = (widget.breakTimeSeconds + (widget.breakTime * 60)) == 0
      ? 60
      : (widget.breakTimeSeconds + (widget.breakTime * 60));
  static const minSeconds = 0;
  int seconds = minSeconds;
  late List<int> repCompare = widget.rep;
  int index = 0;
  Timer? timer;
  late bool exercice = true;
  late bool end = false;
  late bool pauseForSerie = false;
  bool alarm = false;
  static AudioCache _player = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.9)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                color: Colors.blueAccent.withOpacity(0.2),
                height: (displayHeight(context) -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top) *
                    0.17,
                width: displayWidth(context),
                child: (ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          // _addImage(widget.exercices[index]),

                          Container(
                            height: (displayHeight(context) -
                                    kToolbarHeight -
                                    MediaQuery.of(context).padding.top) *
                                0.1,
                            width: displayWidth(context) / 4.5,
                            decoration: const BoxDecoration(),
                            child: IconButton(
                              icon: Image.asset(
                                choseImage(widget.exercices[index]),
                                height: (displayHeight(context) -
                                        kToolbarHeight -
                                        MediaQuery.of(context).padding.top) *
                                    0.1,
                                width: displayWidth(context) / 4.5,
                                fit: BoxFit.scaleDown,
                              ),
                              onPressed: () {},
                            ),
                          ),
                          Text(
                            widget.exercices[index],
                            style: const TextStyle(
                                fontSize: 9, color: Colors.white),
                          ),
                          Row(
                            children: [
                              Text(
                                repCompare[index].toString(),
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                              Text(
                                repCompare[index] > 1 ? " series" : " serie",
                                style: const TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ],
                      );
                    },
                    itemCount: widget.exercices.length)),
              ),
            ),
            go(widget.timeForEx, widget.numberOfSeries, _breakEx, _breakSe,
                widget.rep, widget.exercices),
          ],
        ),
      ),
    );
  }

  Widget go(
    int timeForEx,
    int numberOfSeries,
    int _breakEx,
    int _breakSe,
    List<int> rep,
    List<String> exercices,
  ) {
    return Column(
      children: [
        // debugMyValues(
        // timeForEx, _breakEx, _breakSe, numberOfSeries, rep, exercices),
        timerWidget(
            timeForEx, _breakEx, _breakSe, numberOfSeries, rep, exercices),
      ],
    );
  }

  timerWidget(int timeForEx, int breakEx, int breakSe, int numberOfSeries,
      List<int> rep, List<String> exercices) {
    return Container(
      width: displayWidth(context),
      height: (displayHeight(context)) * 0.82,
      color: Colors.blueAccent.withOpacity(0.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTimer(),
          Container(
            color: Colors.blueAccent.withOpacity(0.2),
            height: displayHeight(context) * 0.3,
            width: displayWidth(context),
            child: IconButton(
              icon: Image.asset(
                end
                    ? "./assets/images/success.png"
                    : exercice
                        ? choseImage(widget.exercices[index])
                        : "./assets/images/drink.png",
                height: (displayHeight(context) -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                width: displayWidth(context),
                fit: BoxFit.scaleDown,
              ),
              onPressed: () {},
            ),
          ),
          detailsExo(),
          buildButtons(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    bool isRunning = timer == null ? false : timer!.isActive;
    return Container(
      width: displayWidth(context),
      height: displayHeight(context) * 0.23,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isRunning
              ? ButtonWidget(
                  text: 'Pause Timer!',
                  onClicked: () {
                    pauseTimer();
                  },
                )
              : end
                  ? Container()
                  : ButtonWidget(
                      text: 'Start Timer!',
                      onClicked: () {
                        startTimer();
                      },
                    ),
        ],
      ),
    );
  }

  Widget buildTimer() {
    int _reverseSecond = _breakEx - seconds;
    if (!end) {
      if (pauseForSerie) {
        _reverseSecond = _breakSe - seconds;
      } else if (exercice) {
        _reverseSecond = widget.timeForEx - seconds;
      } else {
        _reverseSecond = _breakEx - seconds;
      }
      if (alarm && _reverseSecond == 5) {
        myAlarm();
      }
    }

    return Container(
      width: displayWidth(context),
      height: displayHeight(context) * 0.23,
      color: Colors.blueAccent.withOpacity(0.2),
      child: Column(
        children: [
          end
              ? Text(
                  "well done!",
                  style: TextStyle(
                    fontSize: 60,
                  ),
                )
              : Text(
                  "$_reverseSecond",
                  style: TextStyle(
                      color: exercice ? Colors.red : Colors.white,
                      fontSize: 120,
                      fontWeight: FontWeight.w700),
                ),
        ],
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (_) {
      setState(() {
        seconds++;
        if (exercice) {
          if (seconds == widget.timeForEx) {
            exercice = false;
            alarm = true;
            repCompare[index] = repCompare[index] - 1;
            updateIndex();
            seconds = 0;
          }
        } else {
          if (pauseForSerie) {
            if (seconds == _breakSe) {
              alarm = false;
              exercice = true;
              seconds = 0;
              pauseForSerie = false;
            }
          } else if (seconds == _breakEx) {
            alarm = false;
            exercice = true;
            seconds = 0;
          }
        }
      });
    });
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  void endTimer() {
    timer?.cancel();
    setState(() {
      end = true;
    });
  }

  void updateIndex() {
    setState(() {
      if (checkIfAllDone()) {
        endTimer();
      } else if (index < repCompare.length) {
        if (index != repCompare.length - 1) {
          index++;
          if (repCompare[index] == 0) {
            updateIndex();
          }
        } else {
          pauseForSerie = true;

          index = 0;
          if (repCompare[index] == 0) {
            updateIndex();
          }
        }
      }
    });
  }

  bool checkIfAllDone() {
    int i = 0;
    while (i < repCompare.length) {
      if (repCompare[i] != 0) {
        return false;
      } else {
        i++;
      }
    }
    return true;
  }

  Future<AudioPlayer> myAlarm() async {
    return AudioCache().play("./audio/letsgo.mp3");
  }

  Widget detailsExo() {
    if (!end) {
      if (exercice) {
        return Text(
          widget.exercices[index],
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        );
      } else {
        return Text(
          "Pause",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        );
      }
    }
    return Container();
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15)),
        onPressed: onClicked,
        child: Text(
          text,
        ));
  }
}
