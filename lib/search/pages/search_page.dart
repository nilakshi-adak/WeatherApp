import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weatherapp/helper/icon_helper.dart';
import 'package:weatherapp/search/model/search_results.dart';
import 'package:weatherapp/service/current_location_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<SearchResult> searchResults = [];
  Timer? _debounce;
  final WeatherService _weatherService = WeatherService();

  @override
  void dispose() {
    _debounce?.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final background = theme.colorScheme.surface.withValues(alpha: theme.brightness == Brightness.dark ? 0.96 : 0.98);

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28.0),
          topRight: Radius.circular(28.0),
        ),
        border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Hero(
              tag: 'search-hero',
              flightShuttleBuilder: (context, animation, direction, fromContext, toContext) {
                return FadeTransition(
                  opacity: animation.drive(CurveTween(curve: Curves.easeInOut)),
                  child: toContext.widget,
                );
              },
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search any city',
                    hintStyle: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                      fontSize: 16,
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.search,
                      color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5),
                    ),
                    suffixIcon: controller.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(CupertinoIcons.xmark_circle_fill,
                                color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.5)),
                            onPressed: () {
                              controller.clear();
                              _handleQueryChanged('');
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  smartDashesType: SmartDashesType.disabled,
                  smartQuotesType: SmartQuotesType.disabled,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.search,
                  inputFormatters: const [_NoEmojiFormatter()],
                  onChanged: (value) {
                    _handleQueryChanged(value);
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: searchResults.isEmpty
                  ? Center(
                      key: const ValueKey('empty-state'),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          WeatherImage.resolveImage('search.png', height: 90),
                          const SizedBox(height: 12),
                          Text(
                            'Start typing to find a city',
                            style: TextStyle(fontFamily: 'Poppins', color: theme.textTheme.bodyMedium?.color),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Minimum 3 letters. Text only. Emojis are blocked.',
                            style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: theme.textTheme.bodySmall?.color),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      key: const ValueKey('results'),
                      padding: const EdgeInsets.only(bottom: 24),
                      itemBuilder: (context, index) {
                        final result = searchResults[index];
                        final locationMeta = [result.region?.trim(), result.country?.trim()]
                            .whereType<String>()
                            .where((value) => value.isNotEmpty)
                            .join(', ');
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          contentPadding: const EdgeInsets.fromLTRB(24, 0, 16, 0),
                          onTap: () => Navigator.of(context).pop(result),
                          title: Text(
                            result.name ?? 'Loading...',
                            style: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            locationMeta,
                            style: const TextStyle(fontFamily: 'Poppins', fontSize: 12),
                          ),
                          trailing: const Icon(Icons.chevron_right_rounded),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(color: theme.dividerColor.withValues(alpha: 0.2)),
                      itemCount: searchResults.length,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleQueryChanged(String value) {
    final query = value.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 450), () async {
      if (query.length < 3) {
        if (!mounted) return;
        setState(() => searchResults = []);
        return;
      }

      final results = await _weatherService.getSearchResults(query);
      if (!mounted) return;
      if (controller.text.trim() != query) return;
      setState(() => searchResults = results);
    });
  }
}

class _NoEmojiFormatter extends TextInputFormatter {
  const _NoEmojiFormatter();

  static final _emojiRegex = RegExp(
    '[\u{1F300}-\u{1F6FF}\u{1F900}-\u{1F9FF}\u{1F170}-\u{1F1FF}\u{2600}-\u{27BF}]',
    unicode: true,
  );

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final sanitized = newValue.text.replaceAll(_emojiRegex, '');
    if (sanitized == newValue.text) return newValue;
    return TextEditingValue(
      text: sanitized,
      selection: TextSelection.collapsed(offset: sanitized.length),
    );
  }
}
