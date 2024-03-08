import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/icon_helper.dart';

Widget networkBrokenView(BuildContext context) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeatherImage.resolveImage('no-internet.png', height: 110),
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text('Please connect wifi or internet',
              style: TextStyle(fontFamily: 'Poppins')),
        ),
      ],
    ),
  );
}
