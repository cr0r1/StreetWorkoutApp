import 'package:flutter/material.dart';
import 'package:streetworkout/ui/size_helper.dart';
import 'package:streetworkout/ui/start.dart';

class ChooseExercices extends StatefulWidget {
  final int players;
  const ChooseExercices({Key? key, required this.players}) : super(key: key);

  @override
  _ChooseExercicesState createState() => _ChooseExercicesState();
}

class _ChooseExercicesState extends State<ChooseExercices> {
  final Map<String, dynamic> exercices = {
    'Pull ups': true,
    'Dips': false,
    'Push ups': false,
    'Squats': false,
    'Abs': false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _checkExercices()
              ? FloatingActionButton.extended(
                  heroTag: "ftb1",
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return StartScreen(
                          data: exercices,
                        );
                      },
                    ));
                  },
                  backgroundColor: Colors.blueAccent,
                  label: const Text("Go"),
                  icon: const Icon(
                    Icons.forward,
                    size: 40,
                  ))
              : Container(),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton.extended(
            backgroundColor: Colors.blueAccent,
            heroTag: "ftb2",
            onPressed: () {
              _writeExercice(context);
            },
            label: const Text("Add"),
            icon: const Icon(
              Icons.create,
              size: 20,
            ),
          )
        ],
      ),
      appBar: AppBar(
        title: Text(
          "players: ${widget.players}",
          style: settingStyle(),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  onTap: () => setState(() {
                    final key = exercices.keys.elementAt(index);
                    exercices[key] = !exercices[key];
                  }),
                  title: Text(exercices.keys.elementAt(index),
                      style: const TextStyle(fontSize: 20)),
                  leading: _selectionExercices(
                      exercices[exercices.keys.elementAt(index)]),
                  subtitle: Image.asset(
                    choseImage(exercices.keys.elementAt(index)),
                    height: (displayHeight(context) -
                            kToolbarHeight -
                            MediaQuery.of(context).padding.top) *
                        0.07,
                    width: displayWidth(context) / 3,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                const Divider(
                  height: 30,
                  color: Colors.black,
                )
              ],
            );
          },
          itemCount: exercices.length,
        ),
      ),
    );
  }

  Widget _selectionExercices(bool selected) {
    return Icon(
      selected == true ? Icons.check_box : Icons.check_box_outline_blank,
      color: Colors.blueAccent,
      size: 35,
    );
  }

  Future<void> _writeExercice(BuildContext context) async {
    final GlobalKey<FormState> _keyFormState = GlobalKey<FormState>();
    TextEditingController _newExerciceController = TextEditingController();
    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Form(
              key: _keyFormState,
              child: TextFormField(
                autofocus: true,
                keyboardType: TextInputType.text,
                controller: _newExerciceController,
                decoration:
                    const InputDecoration(label: Text("Enter the exercice")),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter the name of your exercice";
                  } else {
                    return null;
                  }
                },
              )),
          actions: [
            TextButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.clear),
                label: const Text("clear")),
            TextButton.icon(
                onPressed: () {
                  if (_keyFormState.currentState!.validate()) {
                    setState(() {
                      exercices[_newExerciceController.text] = true;
                    });
                    Navigator.of(context).pop();
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text("validate"))
          ],
        );
      },
    );
  }

  bool _checkExercices() {
    List<dynamic> data = exercices.values.toList();
    bool test = false;
    data.forEach((element) {
      if (element) {
        test = true;
      }
    });
    return test;
  }
}
