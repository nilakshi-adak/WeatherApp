import 'package:flutter/material.dart';
import 'package:weatherapp/extension/strings.dart';
import 'package:weatherapp/helper/icon_helper.dart';
import 'package:weatherapp/model/current.dart';

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
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          sun('sunrisee.png',
              forecast?.forecastday?[index].astro?.sunrise ?? ''),
          Text(_getTextByIndex(index, forecast),
              style: const TextStyle(fontFamily: 'Poppins')),
          sun('sunset.png', forecast?.forecastday?[index].astro?.sunset ?? ''),
        ],
      ),
      SizedBox(
        height: 90,
        child: ListView.builder(
          itemCount: forecast?.forecastday?[index].hour?.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (BuildContext context, int i) {
            return Card(
              elevation: 2.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 228, 227, 227),
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      padding: const EdgeInsets.only(left: 4, right: 4),
                      child: Text(
                        timeResolver(i),
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            color: Colors.black),
                      ),
                    ),
                    WeatherImage.resolveImage(
                      (forecast?.forecastday?[index].hour?[i].condition?.icon ??
                              '')
                          .toImageDataString(),
                      height: 25,
                    ),
                    Text(
                      '${forecast?.forecastday?[index].hour?[i].tempC}°C',
                      style:
                          const TextStyle(fontFamily: 'Poppins', fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

String timeResolver(int i) {
  if (i == 0) {
    return ('12:00 AM');
  } else if (i < 12) {
    return ('$i:00 AM');
  } else if (i == 12) {
    return ('12:00 PM');
  } else {
    return ('${i - 12}:00 PM');
  }
}

String dateResolver(String date) {
  return '';
}

Widget sun(String imageName, String data) {
  return Column(
    children: [
      SizedBox(
          height: 30, width: 30, child: WeatherImage.resolveImage(imageName)),
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
