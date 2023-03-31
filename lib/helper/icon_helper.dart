import 'package:flutter/material.dart';

class WeatherImage {
  static Image resolveImage(String fileName, {BoxFit? boxFit, double? height, double? opacity}) {
    return Image.asset(
      'assets/images/$fileName',
      height: height,
      fit: boxFit,
      opacity: opacity == null ? null : AlwaysStoppedAnimation(opacity),
    );
  }
}
