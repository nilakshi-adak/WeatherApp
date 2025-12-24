import 'package:flutter/material.dart';
import 'package:weatherapp/views/card.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingView(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: const Color.fromARGB(255, 211, 208, 208),
    highlightColor: Colors.white,
    child: Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          cardLineView(context, 110),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cardLoadingView(context), cardLoadingView(context)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cardLoadingView(context), cardLoadingView(context)],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [cardLoadingView(context), cardLoadingView(context)],
          ),
          cardLineView(context, 55),
          cardLineView(context, 55),
        ],
      ),
    ),
  );
}

Widget cardLoadingView(BuildContext context) {
  return card(Container(), context);
}

Widget cardLineView(BuildContext context, double height) {
  return Card(
    elevation: 3,
    child: Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: height,
      width: MediaQuery.of(context).size.width * 0.92,
    ),
  );
}
