import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/search/model/search_results.dart';
import 'package:flutter_application_1/service/current_location_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<SearchResult> searchResults = [];
  Timer? _debounce;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: CupertinoSearchTextField(
              controller: controller,
              padding: const EdgeInsets.all(14),
              borderRadius: const BorderRadius.all(Radius.circular(25.0)),
              placeholder: 'Search location',
              onChanged: (value) async {
                if (_debounce?.isActive ?? false) _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  // do something with query
                  searchResults.clear();
                  if (value.length > 2) {
                    WeatherService().getSearchResults(value).then((value) {
                      searchResults.addAll(value);
                      setState(() {});
                    });
                  } else if (value.length < 2) {
                    searchResults.clear();
                    setState(() {});
                  }
                });
              },
              autocorrect: true,
            ),
          ),
          Expanded(
            child: searchResults.isEmpty
                ? const Center(
                    child: Text('Minimum 3 letters required to search', style: TextStyle(fontFamily: 'Poppins')),
                  )
                : ListView.separated(
                    itemBuilder: (context, index) => ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(32, 0, 8, 0),
                          onTap: () => Navigator.of(context).pop(searchResults[index]),
                          title: Text(
                            searchResults[index].name ?? 'Loading...',
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                        ),
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: searchResults.length),
          ),
        ],
      ),
    );
  }
}
