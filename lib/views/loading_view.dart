import 'package:flutter/material.dart';
import 'package:weatherapp/views/card.dart';
import 'package:shimmer/shimmer.dart';

Widget loadingView(BuildContext context) {
  return Shimmer.fromColors(
    baseColor: const Color.fromARGB(255, 211, 208, 208),
    highlightColor: Colors.white,
    child: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            cardLineView(context, 160),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: cardLoadingView(context)),
                const SizedBox(width: 14),
                Expanded(child: cardLoadingView(context)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: cardLoadingView(context)),
                const SizedBox(width: 14),
                Expanded(child: cardLoadingView(context)),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: cardLoadingView(context)),
                const SizedBox(width: 14),
                Expanded(child: cardLoadingView(context)),
              ],
            ),
            const SizedBox(height: 18),
            cardLineView(context, 140),
            const SizedBox(height: 80),
          ],
        ),
      ),
    ),
  );
}

Widget cardLoadingView(BuildContext context) {
  return card(
    SizedBox(
      height: 120,
      width: double.infinity,
    ),
    context,
  );
}

Widget cardLineView(BuildContext context, double height) {
  final theme = Theme.of(context);
  final surface = theme.colorScheme.surface.withValues(alpha: 0.98);

  return Container(
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.08)),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: 0.08),
          offset: const Offset(0, 12),
          blurRadius: 24,
          spreadRadius: -12,
        ),
      ],
    ),
    height: height,
    width: double.infinity,
  );
}
