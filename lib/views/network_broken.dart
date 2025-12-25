import 'package:flutter/material.dart';
import 'package:weatherapp/helper/icon_helper.dart';

Widget networkBrokenView(BuildContext context, Function updateUI) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WeatherImage.resolveImage('no-internet.png', height: 140),
          const SizedBox(height: 32),
          const Text(
            'No Internet Connection',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Please connect to wifi or mobile data',
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Poppins',
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => updateUI(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ),
    ),
  );
}
