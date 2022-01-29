import 'package:flutter/material.dart';

Size displaySize(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}

double displayWidth(BuildContext context) {
  debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

TextStyle settingStyle() {
  return const TextStyle(
      color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700);
}

String choseImage(String key) {
  if (key == "Pull ups") {
    return ("assets/images/pull-up.png");
  } else if (key == "Dips") {
    return ("assets/images/dips2.png");
  } else if (key == "Push ups") {
    return ("assets/images/push-up.png");
  } else if (key == "Corde à sauter") {
    return ("assets/images/corde a sauteer.png");
  } else if (key == "Abs") {
    return ("assets/images/photo.png");
  } else if (key == "Squats") {
    return ("assets/images/squat.png");
  } else {
    return ("assets/images/photo.png");
  }
}
