import 'package:flutter/material.dart';
import 'package:weatherapp/extension/strings.dart';
import 'package:weatherapp/helper/icon_helper.dart';
import 'package:weatherapp/model/current.dart';

Widget forecast(BuildContext context, Forecast? forecast) {
  return TweenAnimationBuilder<double>(
    duration: const Duration(milliseconds: 520),
    curve: Curves.easeOutCubic,
    tween: Tween(begin: 30, end: 0),
    builder: (context, value, child) => Transform.translate(offset: Offset(0, value), child: child),
    child: Card(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  '3-Day Outlook',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                Icon(Icons.timeline_rounded, size: 20),
              ],
            ),
            const SizedBox(height: 12),
            forecastRow(context, forecast, 0),
            const Divider(height: 28),
            forecastRow(context, forecast, 1),
            const Divider(height: 28),
            forecastRow(context, forecast, 2),
          ],
        ),
      ),
    ),
  );
}

Widget forecastRow(BuildContext context, Forecast? forecast, int index) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ForecastChip(label: 'Sunrise', value: forecast?.forecastday?[index].astro?.sunrise ?? '--'),
          Text(
            _getTextByIndex(index, forecast),
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          _ForecastChip(label: 'Sunset', value: forecast?.forecastday?[index].astro?.sunset ?? '--'),
        ],
      ),
      const SizedBox(height: 16),
      SizedBox(
        height: 110,
        child: ListView.separated(
          itemCount: forecast?.forecastday?[index].hour?.length ?? 0,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (_, __) => const SizedBox(width: 10),
          itemBuilder: (BuildContext context, int i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    timeResolver(i),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  WeatherImage.resolveImage(
                    (forecast?.forecastday?[index].hour?[i].condition?.icon ?? '').toImageDataString(),
                    height: 32,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${forecast?.forecastday?[index].hour?[i].tempC}°',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
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
  return Row(
    children: [
      SizedBox(
        height: 24,
        width: 24,
        child: WeatherImage.resolveImage(imageName),
      ),
      const SizedBox(width: 6),
      Text(
        data,
        style: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}


String _getTextByIndex(int index, Forecast? forecast) {
  if (index == 0) return 'Today';
  if (index == 1) return 'Tomorrow';
  if (index == 2) return 'Day after Tomorrow';
  return '';
}

class _ForecastChip extends StatelessWidget {
  const _ForecastChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 11,
            color: (Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7)) ?? Colors.white70,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
