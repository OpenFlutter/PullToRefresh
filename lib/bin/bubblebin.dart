import 'package:flutter/material.dart';

class BubbleBin {
  double radius;
  double speed;
  double disappearHeight;
  Color color;
  int transparency;
  double xPosition;
  double yPosition;

  BubbleBin({
    @required this.radius,
    @required this.speed,
    @required this.disappearHeight,
    @required this.color,
    @required this.transparency,
    @required this.xPosition,
    @required this.yPosition
  });

  @override
  String toString() {
    return 'BubbleBin{radius: $radius, speed: $speed, disappearHeight: $disappearHeight, color: $color, transparency: $transparency, xPosition: $xPosition, yPosition: $yPosition}';
  }

}