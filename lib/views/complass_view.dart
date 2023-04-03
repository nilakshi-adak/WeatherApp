import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/icon_helper.dart';

Widget compassView(String angle) {
  return Center(
    child: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: SizedBox(height: 90, width: 90, child: WeatherImage.resolveImage('direction.png', opacity: 0.3)),
        ),
        Padding(
            padding: const EdgeInsets.all(30.0),
            child: Transform.rotate(
              angle: double.parse(angle),
              child: SizedBox(height: 55, width: 55, child: WeatherImage.resolveImage('up-arrow.png')),
            )),
      ],
    ),
  );
}
