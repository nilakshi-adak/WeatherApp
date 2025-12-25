import 'package:flutter/material.dart';
import 'package:weatherapp/constant/constant.dart';
import 'package:weatherapp/extension/strings.dart';
import 'package:weatherapp/helper/icon_helper.dart';
import 'package:weatherapp/model/current.dart';

Widget cardMain(CurrentLocation location, String userConsent) {
  final dynamic isDayFlag = location.current?.isDay;
  final isDay = isDayFlag == 1 || isDayFlag == '1';
  final double temp = double.tryParse('${location.current?.tempC ?? 0}') ?? 0;
  final double feelsLike = double.tryParse('${location.current?.feelslikeC ?? temp}') ?? temp;
  final double wind = double.tryParse('${location.current?.windKph ?? 0}') ?? 0;
  final int humidity = int.tryParse('${location.current?.humidity ?? 0}') ?? 0;
  final gradient = isDay
      ? const [Color(0xFF6A8CFF), Color(0xFF8BE9FF)]
      : const [Color(0xFF1F1C3B), Color(0xFF462B7A)];

  return AnimatedContainer(
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeOutCubic,
    margin: const EdgeInsets.symmetric(vertical: 12),
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
      borderRadius: BorderRadius.circular(36),
      boxShadow: const [
        BoxShadow(color: Color(0x33000000), offset: Offset(0, 24), blurRadius: 40, spreadRadius: -16),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TweenAnimationBuilder<double>(
                    key: ValueKey(location.current?.lastUpdatedEpoch ?? location.location?.name),
                    tween: Tween<double>(begin: temp - 4, end: temp),
                    duration: const Duration(milliseconds: 900),
                    curve: Curves.easeOutQuint,
                    builder: (context, animatedTemp, _) => Text(
                      '${animatedTemp.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                        fontSize: 54,
                        fontWeight: FontWeight.w600,
                        height: 1.1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location.current?.condition?.text ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.location?.name ?? 'Loading...',
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          location.location?.region ?? '',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins',
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        if (userConsent == StringConstant.locationDenied)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              StringConstant.locationDisabledMessage,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                color: Colors.orange.shade100,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: KeyedSubtree(
                key: ValueKey(location.current?.condition?.icon),
                child: WeatherImage.resolveImage(
                  location.current?.condition?.icon?.toImageDataString() ?? 'sunrise.png',
                  height: 140,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 20,
          runSpacing: 12,
          children: [
            _HeroStat(label: 'Feels like', value: '${feelsLike.toStringAsFixed(1)}°C'),
            _HeroStat(label: 'Wind', value: '${wind.toStringAsFixed(1)} km/h'),
            _HeroStat(label: 'Humidity', value: '$humidity%'),
          ],
        ),
      ],
    ),
  );
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.white70,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
