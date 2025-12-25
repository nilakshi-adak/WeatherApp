import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:weatherapp/helper/icon_helper.dart';

Widget compassView(String angle) {
  final degrees = double.tryParse(angle) ?? 0;
  final radians = degrees * (math.pi / 180);
  
  return Center(
    child: Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 70,
          width: 70,
          child: WeatherImage.resolveImage('direction.png', opacity: 0.2),
        ),
        Transform.rotate(
          angle: radians,
          child: SizedBox(
            height: 40,
            width: 40,
            child: WeatherImage.resolveImage('up-arrow.png'),
          ),
        ),
      ],
    ),
  );
}
