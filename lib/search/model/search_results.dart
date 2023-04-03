List<SearchResult> searchResultFromJson(List<dynamic> str) {
  return str.map((e) => SearchResult.fromJson(e)).toList();
}

class SearchResult {
  SearchResult({
    this.id,
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.url,
  });

  final int? id;
  final String? name;
  final String? region;
  final String? country;
  final double? lat;
  final double? lon;
  final String? url;

  factory SearchResult.fromJson(Map<dynamic, dynamic> json) => SearchResult(
        id: json["id"],
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        url: json["url"],
      );
}
