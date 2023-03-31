import 'package:flutter/material.dart';

Widget card(Widget child, BuildContext context) {
  return Card(
    elevation: 3,
    child: Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 110,
      width: MediaQuery.of(context).size.width * 0.44,
      child: child,
    ),
  );
}
