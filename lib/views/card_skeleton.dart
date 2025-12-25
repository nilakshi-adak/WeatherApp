import 'package:flutter/material.dart';
import 'package:weatherapp/helper/icon_helper.dart';

Widget cardSkeleton(String badgeString, String info, String imagePath, {String? extraInfo}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      if (badgeString.isNotEmpty)
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            badgeString,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      const Spacer(),
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Flexible(
                  child: Text(
                    info,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (extraInfo != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Text(
                      extraInfo,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (imagePath.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: WeatherImage.resolveImage(imagePath, height: 32),
            ),
        ],
      ),
    ],
  );
}
