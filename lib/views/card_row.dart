import 'package:flutter/material.dart';
import 'package:weatherapp/views/card.dart';
import 'package:weatherapp/views/card_skeleton.dart';
import 'package:weatherapp/views/complass_view.dart';

Widget cardRow(
  BuildContext context,
  String message1,
  String message2,
  String remoteData1,
  String remoteData2,
  String image1,
  String image2,
  String? extraInfo1,
  String? extraInfo2,
  bool isDiffChild,
  {int rowIndex = 0}) {
  final offset = 36.0 + (rowIndex * 6);
  return TweenAnimationBuilder<double>(
    duration: Duration(milliseconds: 420 + rowIndex * 80),
    tween: Tween(begin: offset, end: 0),
    curve: Curves.easeOutCubic,
    builder: (context, value, child) => Transform.translate(
      offset: Offset(0, value),
      child: Opacity(
        opacity: (1 - (value / (offset + 0.01))).clamp(0.4, 1),
        child: child,
      ),
    ),
    child: Row(
      children: [
        Expanded(
          child: card(
            !isDiffChild
                ? cardSkeleton(message1, remoteData1, image1, extraInfo: extraInfo1)
                : compassView(remoteData1),
            context,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: card(
            cardSkeleton(message2, remoteData2, image2, extraInfo: extraInfo2),
            context,
          ),
        ),
      ],
    ),
  );
}
