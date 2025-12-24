import 'package:flutter/cupertino.dart';
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
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      card(!isDiffChild ? cardSkeleton(message1, remoteData1, image1, extraInfo: extraInfo1) : compassView(remoteData1),
          context),
      card(cardSkeleton(message2, remoteData2, image2, extraInfo: extraInfo2), context),
    ],
  );
}
