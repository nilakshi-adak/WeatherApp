import 'package:flutter/material.dart';
import 'package:weatherapp/helper/icon_helper.dart';

Widget cardSkeleton(String badgeString, String info, String imagePath,
    {String? extraInfo}) {
  return Row(
    children: [
      Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 237, 233, 233),
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(8),
                          topLeft: Radius.circular(4))),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(badgeString),
                ),
              ],
            ),
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(
                          info,
                          style: const TextStyle(
                              fontSize: 35.0,
                              color: Colors.grey,
                              fontFamily: 'Poppins'),
                        ),
                        if (extraInfo != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Text(
                              extraInfo,
                              style: const TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.grey,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
                height: 30,
                width: 30,
                child: WeatherImage.resolveImage(imagePath)),
          ),
        ],
      ),
    ],
  );
}
