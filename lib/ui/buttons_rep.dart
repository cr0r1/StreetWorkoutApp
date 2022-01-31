import 'package:flutter/material.dart';
import 'package:streetworkout/ui/timer.dart';
import './size_helper.dart';

class ButtonsRep extends StatefulWidget {
  final List<String> exercices;
  final List<int> rep;
  final Map<String, dynamic> data;

  const ButtonsRep({
    Key? key,
    required this.exercices,
    required this.rep,
    required this.data,
  }) : super(key: key);

  @override
  _ButtonsRepState createState() => _ButtonsRepState();
}

class _ButtonsRepState extends State<ButtonsRep> {
  int _breakTime = 0;
  int _breakTimeSeconds = 60;
  int _breakExercice = 0;
  int _breakExerciceSeconds = 60;
  int _numberOfSeries = 2;
  int _timeForEx = 30;
  bool bs = true;
  bool be = true;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.blueAccent.withOpacity(0.2),
          height: (displayHeight(context) -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top) *
              0.13,
          width: displayWidth(context),
          child: (ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    // _addImage(widget.exercices[index]),
                    Row(
                      children: [
                        Text(
                          widget.rep[index].toString(),
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const Text(
                          " series",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    Text(
                      widget.exercices[index],
                      style: const TextStyle(fontSize: 9, color: Colors.white),
                    ),
                    Container(
                      height: (displayHeight(context) -
                              kToolbarHeight -
                              MediaQuery.of(context).padding.top) *
                          0.075,
                      width: displayWidth(context) / 4.5,
                      decoration: const BoxDecoration(),
                      child: IconButton(
                        icon: Image.asset(
                          choseImage(widget.exercices[index]),
                          height: (displayHeight(context) -
                                  kToolbarHeight -
                                  MediaQuery.of(context).padding.top) *
                              0.1,
                          width: displayWidth(context) / 3,
                          fit: BoxFit.scaleDown,
                        ),
                        onPressed: () {
                          setState(() {
                            if (widget.rep[index] > 0) {
                              widget.rep[index]--;
                              // widget.notifyParent(index);
                            }
                          });
                        },
                      ),
                    ),
                  ],
                );
              },
              itemCount: widget.exercices.length)),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          "Series: ${_numberOfSeries.toString()}",
          style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Slider(
          activeColor: Colors.white,
          inactiveColor: Colors.blueAccent,
          divisions: 30,
          min: 2,
          max: 35,
          value: _numberOfSeries.toDouble(),
          onChanged: (value) {
            setState(() {
              _numberOfSeries = value.round();
              int i = 0;
              while (i < widget.rep.length) {
                widget.rep[i] = value.round();
                i++;
              }
            });
          },
        ),
        const Text(
          "Break between series:",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        // ${_breakTime.toString()} second
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.blueAccent,
              min: 0,
              max: 60,
              divisions: 60,
              value: _breakTimeSeconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _breakTimeSeconds = value.round();
                });
              },
            ),
            Row(
              children: [
                Text(
                  " ${_breakTimeSeconds.toString()} ",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const Text(
                  "seconds",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.blueAccent,
              min: 0,
              max: 10,
              divisions: 10,
              value: _breakTime.toDouble(),
              onChanged: (value) {
                setState(() {
                  _breakTime = value.round();
                });
              },
            ),
            Row(
              children: [
                Text(
                  " ${_breakTime.toString()} ",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const Text(
                  "Minutes",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "Between exercices:",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.blueAccent,
            min: 0,
            max: 60,
            divisions: 60,
            value: _breakExerciceSeconds.toDouble(),
            onChanged: (value) {
              setState(() {
                _breakExerciceSeconds = value.round();
              });
            },
          ),
          Row(
            children: [
              Text(
                " ${_breakExerciceSeconds.toString()} ",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const Text(
                "Seconds",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ]),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.blueAccent,
              min: 0,
              max: 10,
              divisions: 10,
              value: _breakExercice.toDouble(),
              onChanged: (value) {
                setState(() {
                  _breakExercice = value.round();
                });
              },
            ),
            Row(
              children: [
                Text(
                  " ${_breakExercice.toString()} ",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const Text(
                  "Minutes",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
        const Text(
          "Time for your exercices: ",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.blueAccent,
              min: 10,
              max: 60,
              divisions: 60,
              value: _timeForEx.toDouble(),
              onChanged: (value) {
                setState(() {
                  _timeForEx = value.round();
                });
              },
            ),
            Row(
              children: [
                Text(
                  " ${_timeForEx.toString()} ",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ),
                const Text(
                  "Seconds",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ],
        ),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return Timerr(
                  exercices: widget.exercices,
                  rep: widget.rep,
                  breakExercice: _breakExercice,
                  breakExerciceSeconds: _breakExerciceSeconds,
                  breakTime: _breakTime,
                  breakTimeSeconds: _breakTimeSeconds,
                  numberOfSeries: _numberOfSeries,
                  timeForEx: _timeForEx,
                );
              },
            ));
          },
          child: Padding(
            padding: const EdgeInsets.all(23.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.blueAccent.withOpacity(0.3),
                  border: Border.all(width: 4, color: Colors.blueAccent)),
              height: 100,
              width: 120,
              child: const Center(
                  child: Text(
                "START",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.w600),
              )),
            ),
          ),
        )
      ],
    );
  }
}
