import 'package:flutter/material.dart';

<<<<<<< HEAD
=======
int currentIconIndex = -1;
Color currentIconColor = Colors.black;

>>>>>>> ff7a751468dc6dc978ca77efdbc3b8d64aa9bfb0
IconStack iconStack = IconStack(icons: [
  PositionedIcon(
      icon: Icons.ac_unit_rounded,
      size: 0.1,
      x: 0.1,
      y: 0.1,
      color: Colors.blue),
  PositionedIcon(
      icon: Icons.access_alarm, size: 0.1, x: 0.8, y: 0.6, color: Colors.green),
]);

class PositionedIcon {
  final IconData icon;
  double size;
  double x;
  double y;
  Color? color;

  PositionedIcon({
    required this.icon,
    required this.size,
    required this.x,
    required this.y,
    this.color,
  });
}

class IconStack extends ChangeNotifier {
<<<<<<< HEAD
  int currentIconIndex = -1;
  Color currentIconColor = Colors.black;
=======
>>>>>>> ff7a751468dc6dc978ca77efdbc3b8d64aa9bfb0
  final List<PositionedIcon> icons;
  IconStack({required this.icons});
  void notify() {
    notifyListeners();
  }
}
