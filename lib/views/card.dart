import 'package:flutter/material.dart';

Widget card(Widget child, BuildContext context) {
  final theme = Theme.of(context);
  final surface = theme.colorScheme.surface
      .withValues(alpha: theme.brightness == Brightness.dark ? 0.65 : 0.98);

  return AnimatedContainer(
    duration: const Duration(milliseconds: 350),
    curve: Curves.easeOutCubic,
    padding: const EdgeInsets.all(18),
    height: 120,
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(26),
      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.08)),
      boxShadow: [
        BoxShadow(
          color: theme.shadowColor.withValues(alpha: theme.brightness == Brightness.dark ? 0.25 : 0.08),
          offset: const Offset(0, 12),
          blurRadius: 24,
          spreadRadius: -12,
        ),
      ],
    ),
    child: child,
  );
}
