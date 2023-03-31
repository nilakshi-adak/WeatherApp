import 'package:flutter/material.dart';
import 'package:flutter_application_1/helper/icon_helper.dart';
import 'package:flutter_application_1/model/current.dart';

Widget forecast(BuildContext context, Forecast? forecast) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            forecastRow(forecast, 0),
            const Divider(),
            forecastRow(forecast, 1),
            const Divider(),
            forecastRow(forecast, 2),
          ],
        )),
  );
}

Widget forecastRow(Forecast? forecast, int index) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      sun('sunrise.png', forecast?.forecastday?[index].astro?.sunrise ?? ''),
      Text(_getTextByIndex(index, forecast), style: const TextStyle(fontFamily: 'Poppins')),
      sun('sunset.png', forecast?.forecastday?[index].astro?.sunset ?? ''),
    ],
  );
}

String dateResolver(String date) {
  return '';
}

Widget sun(String imageName, String data) {
  return Column(
    children: [
      SizedBox(height: 30, width: 30, child: WeatherImage.resolveImage(imageName)),
      Text(data, style: const TextStyle(fontFamily: 'Poppins')),
    ],
  );
}

String _getTextByIndex(int index, Forecast? forecast) {
  if (index == 0) return 'Today';
  if (index == 1) return 'Tomorrow';
  if (index == 2) return 'Day after Tomorrow';
  return '';
}
