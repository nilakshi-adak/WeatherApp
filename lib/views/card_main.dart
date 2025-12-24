import 'package:flutter/material.dart';
import 'package:weatherapp/constant/constant.dart';
import 'package:weatherapp/extension/strings.dart';
import 'package:weatherapp/helper/icon_helper.dart';
import 'package:weatherapp/model/current.dart';

Widget cardMain(CurrentLocation location, String userConsent) {
  return Card(
    margin: const EdgeInsets.all(20),
    elevation: 3,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            trailing: WeatherImage.resolveImage(location.current!.condition!.icon!.toImageDataString()),
            // trailing: WeatherImage.getData(location.current?.condition?.code.toString()),
            title: Text('${location.current?.tempC.toString()}°C', style: const TextStyle(fontSize: 32.0)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.location?.name ?? 'loading..', style: const TextStyle(fontFamily: 'Poppins')),
                Text(location.location?.region ?? 'loading..', style: const TextStyle(fontFamily: 'Poppins')),
                if (userConsent == StringConstant.locationDenied)
                  Text(StringConstant.locationDisabledMessage,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
