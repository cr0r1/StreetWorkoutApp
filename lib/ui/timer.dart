import 'package:flutter/material.dart';
import './size_helper.dart';
import 'dart:async';

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
  late int _breakEx = widget.breakExerciceSeconds + (widget.breakExercice * 60);
  late int _breakSe = widget.breakTimeSeconds + (widget.breakTime * 60);
  static const minSeconds = 0;
  int seconds = minSeconds;
  late List<int> repCompare = widget.rep;
  int index = 0;
  Timer? timer;
  late bool series = false;
  late bool exercice = true;
  late bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: displayHeight(context),
        width: displayWidth(context),
        decoration: BoxDecoration(color: Colors.blueAccent.withOpacity(0.9)),
        child: Column(
          children: [
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
        debugMyValues(
            timeForEx, _breakEx, _breakSe, numberOfSeries, rep, exercices),
        timerWidget(
            timeForEx, _breakEx, _breakSe, numberOfSeries, rep, exercices),
      ],
    );
  }

  Widget debugMyValues(
    int timeForEx,
    int _breakEx,
    int _breakSe,
    int numberOfSeries,
    List<int> rep,
    List<String> exercices,
  ) {
    return Container(
      width: displayWidth(context),
      height: displayHeight(context) * 0.24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 24,
          ),
          Text(
            "time pour realiser l'exo: $timeForEx",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "time entre chaque exo: $_breakEx",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "time entre chaque serie: $_breakSe",
            style: const TextStyle(fontSize: 20),
          ),
          Text(
            "nb of reps: $rep",
            style: const TextStyle(fontSize: 15),
          ),
          Text(
            "nb of repsComp: $repCompare",
            style: const TextStyle(fontSize: 15),
          ),
          Text(
            "names of exercices: $exercices",
            style: const TextStyle(fontSize: 15),
          ),
          const Divider(
            height: 10,
          ),
        ],
      ),
    );
  }

  timerWidget(int timeForEx, int breakEx, int breakSe, int numberOfSeries,
      List<int> rep, List<String> exercices) {
    return Container(
      width: displayWidth(context),
      height: displayHeight(context) * 0.76,
      color: Colors.yellow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildTimer(),
          exercice
              ? Container(
                  height: (displayHeight(context) -
                          kToolbarHeight -
                          MediaQuery.of(context).padding.top) *
                      0.2,
                  width: displayWidth(context) / 3,
                  decoration: const BoxDecoration(),
                  child: IconButton(
                    icon: Image.asset(
                      choseImage(widget.exercices[index]),
                      height: (displayHeight(context) -
                              kToolbarHeight -
                              MediaQuery.of(context).padding.top) *
                          0.2,
                      width: displayWidth(context) / 3,
                      fit: BoxFit.scaleDown,
                    ),
                    onPressed: () {},
                  ),
                )
              : Text("ZZZZzzzzzzzzzz"),
          buildButtons(),
        ],
      ),
    );
  }

  Widget buildButtons() {
    bool isRunning = timer == null ? false : timer!.isActive;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        isRunning
            ? ButtonWidget(
                text: 'Pause Timer!',
                onClicked: () {
                  pauseTimer();
                },
              )
            : ButtonWidget(
                text: 'Start Timer!',
                onClicked: () {
                  startTimer();
                },
              ),
      ],
    );
  }

  Widget buildTimer() {
    // int _reverseSecond = _breakEx - seconds;

    return Text(
      "$seconds",
      style: TextStyle(
          color: exercice ? Colors.red : Colors.white,
          fontSize: 100,
          fontWeight: FontWeight.w700),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (value) {
      setState(() {
        if (!checkIfAllDone() && index != -1) {
          seconds = seconds + 2;
          if (exercice || series) {
            breakMethodEx();
          } else {
            updateRepCompare(); //remets l'index au bon endroit et update repCompare si ya besoino
            if (checkOurPosition()) {
              if (seconds % _breakEx == 0) {
                if (firstTime) {
                  repCompare[0] = repCompare[0] - 1;
                  index++;
                  firstTime = false;
                }
                seconds = 0;
                //pause pr l'exo
                exercice = true;
              }
            } else {
              if (seconds % _breakSe == 0) {
                if (firstTime) {
                  repCompare[0] = repCompare[0] - 1;
                  index++;
                  firstTime = false;
                }
                seconds = 0;
                // breakMethodSe();
                //pause pour l'exo
                series = true;
              }
            }
          } // here we update the routine;
        } else if (checkIfAllDone()) {
          ///////////ici faut metttre alarme
          alarmTimer();
        }
      });
    });
  }

  bool checkIfAllDone() {
    int i = 0;
    while (i < widget.rep.length) {
      if (repCompare[i] != 0) {
        return false;
      } else {
        i++;
      }
    }
    return true;
  }

  void pauseTimer() {
    setState(() {
      timer?.cancel();
    });
  }

  void updateRepCompare() {
    bool betweenEx =
        checkOurPosition(); // si on est sur un ex ou une fin de serie
    if (betweenEx && seconds % _breakEx == 0) {
      setState(() {
        repCompare[index] = repCompare[index] - 1;

        updateIndex();
      });
    } else if (!betweenEx &&
        seconds % _breakSe ==
            0) // un boolean qui nous dit si on est entre ex ou serie
    {
      setState(() {
        repCompare[index] = repCompare[index] - 1;
        updateIndex();
      });
      // une variable qui se rappelle on est où dans notre table, circuit
    } else {
      return;
    }
  }

  bool checkOurPosition() {
    int tmp = index + 1;
    while (tmp < repCompare.length) {
      if (repCompare[tmp] != 0) return true;
      tmp++;
    }
    return false; //si on est entre ex ou se
  }

  void updateIndex() {
    setState(() {
      if (index < repCompare.length - 1) {
        index++;
        if (repCompare[index] == 0) {
          if (checkIfAllDone()) {
            index == -1;
            return;
          }
          updateIndex();
        }
      } else {
        index = 0;
        if (repCompare[index] == 0) {
          if (checkIfAllDone()) {
            index == -1;
            return;
          }
          updateIndex();
        }
      }
    });
  }

  void alarmTimer() {
    timer?.cancel();
  }

  void breakMethodEx() {
    // ici on gerer le temps d' exo et la pause de la serie, on pourra peut etre rajouter methode alarme
    if (exercice) {
      if (seconds % widget.timeForEx == 0) {
        setState(() {
          seconds = 0;
          exercice = false;
        });
      }
    } else {
      if (seconds % _breakSe == 0) {
        setState(() {
          seconds = 0;
          series = false;
        });
      }
    }
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


/*  // Container(
            //   height: (displayHeight(context) -
            //           kToolbarHeight -
            //           MediaQuery.of(context).padding.top) *
            //       0.13,
            //   width: displayWidth(context),
            //   child: (ListView.builder(
            //       scrollDirection: Axis.horizontal,
            //       itemBuilder: (context, index) {
            //         return Column(
            //           children: [
            //             // _addImage(widget.exercices[index]),
            //             Row(
            //               children: [
            //                 Text(
            //                   widget.rep[index].toString(),
            //                   style: const TextStyle(
            //                       fontSize: 20,
            //                       fontWeight: FontWeight.w600,
            //                       color: Colors.white),
            //                 ),
            //                 const Text(
            //                   " series",
            //                   style: TextStyle(color: Colors.white),
            //                 )
            //               ],
            //             ),
            //             Text(
            //               widget.exercices[index],
            //               style:
            //                   const TextStyle(fontSize: 9, color: Colors.white),
            //             ),
            //             Container(
            //               height: (displayHeight(context) -
            //                       kToolbarHeight -
            //                       MediaQuery.of(context).padding.top) *
            //                   0.075,
            //               width: displayWidth(context) / 4.5,
            //               decoration: const BoxDecoration(),
            //               child: IconButton(
            //                 icon: Image.asset(
            //                   choseImage(widget.exercices[index]),
            //                   height: (displayHeight(context) -
            //                           kToolbarHeight -
            //                           MediaQuery.of(context).padding.top) *
            //                       0.1,
            //                   width: displayWidth(context) / 3,
            //                   fit: BoxFit.scaleDown,
            //                 ),
            //                 onPressed: () {
            //                   setState(() {
            //                     if (widget.rep[index] > 0) {
            //                       widget.rep[index]--;
            //                       // widget.notifyParent(index);
            //                     }
            //                   });
            //                 },
            //               ),
            //             ),
            //           ],
            //         );
            //       },
            //       itemCount: widget.exercices.length)),
            // ),*/