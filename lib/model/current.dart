class CurrentLocation {
  CurrentLocation({
    this.location,
    this.current,
    this.forecast,
  });

  final Location? location;
  final Current? current;
  final Forecast? forecast;

  factory CurrentLocation.fromJson(Map<String, dynamic> json) => CurrentLocation(
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
        current: json["current"] == null ? null : Current.fromJson(json["current"]),
        forecast: json["forecast"] == null ? null : Forecast.fromJson(json["forecast"]),
      );
}

class Current {
  Current({
    this.lastUpdatedEpoch,
    this.lastUpdated,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.visKm,
    this.visMiles,
    this.uv,
    this.gustMph,
    this.gustKph,
  });

  final Condition? condition;
  final String? lastUpdatedEpoch;
  final String? lastUpdated;
  final String? tempC;
  final String? tempF;
  final String? isDay;
  final String? windMph;
  final String? windKph;
  final String? windDegree;
  final String? windDir;
  final String? pressureMb;
  final String? pressureIn;
  final String? precipMm;
  final String? precipIn;
  final String? humidity;
  final String? cloud;
  final String? feelslikeC;
  final String? feelslikeF;
  final String? visKm;
  final String? visMiles;
  final String? uv;
  final String? gustMph;
  final String? gustKph;

  factory Current.fromJson(Map<String, dynamic> json) => Current(
        condition: json["condition"] == null ? null : Condition.fromJson(json["condition"]),
        lastUpdatedEpoch: json["last_updated_epoch"].toString(),
        lastUpdated: json["last_updated"].toString(),
        tempC: json["temp_c"].toString(),
        tempF: json["temp_f"].toString(),
        isDay: json["is_day"].toString(),
        windMph: json["wind_mph"].toString(),
        windKph: json["wind_kph"].toString(),
        windDegree: json["wind_degree"].toString(),
        windDir: json["wind_dir"].toString(),
        pressureMb: json["pressure_mb"].toString(),
        pressureIn: json["pressure_in"].toString(),
        precipMm: json["precip_mm"].toString(),
        precipIn: json["precip_in"].toString(),
        humidity: json["humidity"].toString(),
        cloud: json["cloud"].toString(),
        feelslikeC: json["feelslike_c"].toString(),
        feelslikeF: json["feelslike_f"].toString(),
        visKm: json["vis_km"].toString(),
        visMiles: json["vis_miles"].toString(),
        uv: json["uv"].toString(),
        gustMph: json["gust_mph"].toString(),
        gustKph: json["gust_kph"].toString(),
      );
}

// https://www.weatherapi.com/docs/weather_conditions.json
class Condition {
  Condition({
    this.text,
    this.icon,
    this.code,
  });

  final String? text;
  final String? icon;
  final int? code;

  factory Condition.fromJson(Map<String, dynamic> json) => Condition(
        text: json["text"],
        icon: json["icon"],
        code: json["code"],
      );
}

class Location {
  Location({
    this.name,
    this.region,
    this.country,
    this.lat,
    this.lon,
    this.tzId,
    this.localtimeEpoch,
    this.localtime,
  });

  final String? name;
  final String? region;
  final String? country;
  final double? lat;
  final double? lon;
  final String? tzId;
  final int? localtimeEpoch;
  final String? localtime;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        name: json["name"],
        region: json["region"],
        country: json["country"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        tzId: json["tz_id"],
        localtimeEpoch: json["localtime_epoch"],
        localtime: json["localtime"],
      );
}

class Forecast {
  Forecast({
    this.forecastday,
  });

  final List<Forecastday>? forecastday;

  factory Forecast.fromJson(Map<String, dynamic> json) => Forecast(
        forecastday: json["forecastday"] == null
            ? []
            : List<Forecastday>.from(json["forecastday"]!.map((x) => Forecastday.fromJson(x))),
      );
}

class Forecastday {
  Forecastday({
    this.date,
    this.dateEpoch,
    this.day,
    this.astro,
    this.hour,
  });

  final DateTime? date;
  final int? dateEpoch;
  final Day? day;
  final Astro? astro;
  final List<Hour>? hour;

  factory Forecastday.fromJson(Map<String, dynamic> json) => Forecastday(
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        dateEpoch: json["date_epoch"],
        day: json["day"] == null ? null : Day.fromJson(json["day"]),
        astro: json["astro"] == null ? null : Astro.fromJson(json["astro"]),
        hour: json["hour"] == null ? [] : List<Hour>.from(json["hour"]!.map((x) => Hour.fromJson(x))),
      );
}

class Astro {
  Astro({
    this.sunrise,
    this.sunset,
    this.moonrise,
    this.moonset,
    this.moonPhase,
    this.moonIllumination,
    this.isMoonUp,
    this.isSunUp,
  });

  final String? sunrise;
  final String? sunset;
  final String? moonrise;
  final String? moonset;
  final String? moonPhase;
  final String? moonIllumination;
  final String? isMoonUp;
  final String? isSunUp;

  factory Astro.fromJson(Map<String, dynamic> json) => Astro(
        sunrise: json["sunrise"].toString(),
        sunset: json["sunset"].toString(),
        moonrise: json["moonrise"].toString(),
        moonset: json["moonset"].toString(),
        moonPhase: json["moon_phase"].toString(),
        moonIllumination: json["moon_illumination"].toString(),
        isMoonUp: json["is_moon_up"].toString(),
        isSunUp: json["is_sun_up"].toString(),
      );
}

class Day {
  Day({
    this.maxtempC,
    this.maxtempF,
    this.mintempC,
    this.mintempF,
    this.avgtempC,
    this.avgtempF,
    this.maxwindMph,
    this.maxwindKph,
    this.totalprecipMm,
    this.totalprecipIn,
    this.totalsnowCm,
    this.avgvisKm,
    this.avgvisMiles,
    this.avghumidity,
    this.dailyWillItRain,
    this.dailyChanceOfRain,
    this.dailyWillItSnow,
    this.dailyChanceOfSnow,
    this.condition,
    this.uv,
  });

  final String? maxtempC;
  final String? maxtempF;
  final String? mintempC;
  final String? mintempF;
  final String? avgtempC;
  final String? avgtempF;
  final String? maxwindMph;
  final String? maxwindKph;
  final String? totalprecipMm;
  final String? totalprecipIn;
  final String? totalsnowCm;
  final String? avgvisKm;
  final String? avgvisMiles;
  final String? avghumidity;
  final String? dailyWillItRain;
  final String? dailyChanceOfRain;
  final String? dailyWillItSnow;
  final String? dailyChanceOfSnow;
  final Condition? condition;
  final String? uv;

  factory Day.fromJson(Map<String, dynamic> json) => Day(
        maxtempC: json["maxtemp_c"].toString(),
        maxtempF: json["maxtemp_f"].toString(),
        mintempC: json["mintemp_c"].toString(),
        mintempF: json["mintemp_f"].toString(),
        avgtempC: json["avgtemp_c"].toString(),
        avgtempF: json["avgtemp_f"].toString(),
        maxwindMph: json["maxwind_mph"].toString(),
        maxwindKph: json["maxwind_kph"].toString(),
        totalprecipMm: json["totalprecip_mm"].toString(),
        totalprecipIn: json["totalprecip_in"].toString(),
        totalsnowCm: json["totalsnow_cm"].toString(),
        avgvisKm: json["avgvis_km"].toString(),
        avgvisMiles: json["avgvis_miles"].toString(),
        avghumidity: json["avghumidity"].toString(),
        dailyWillItRain: json["daily_will_it_rain"].toString(),
        dailyChanceOfRain: json["daily_chance_of_rain"].toString(),
        dailyWillItSnow: json["daily_will_it_snow"].toString(),
        dailyChanceOfSnow: json["daily_chance_of_snow"].toString(),
        condition: json["condition"] == null ? null : Condition.fromJson(json["condition"]),
        uv: json["uv"].toString(),
      );
}

class Hour {
  Hour({
    this.timeEpoch,
    this.time,
    this.tempC,
    this.tempF,
    this.isDay,
    this.condition,
    this.windMph,
    this.windKph,
    this.windDegree,
    this.windDir,
    this.pressureMb,
    this.pressureIn,
    this.precipMm,
    this.precipIn,
    this.humidity,
    this.cloud,
    this.feelslikeC,
    this.feelslikeF,
    this.windchillC,
    this.windchillF,
    this.heatindexC,
    this.heatindexF,
    this.dewpointC,
    this.dewpointF,
    this.willItRain,
    this.chanceOfRain,
    this.willItSnow,
    this.chanceOfSnow,
    this.visKm,
    this.visMiles,
    this.gustMph,
    this.gustKph,
    this.uv,
  });

  final String? timeEpoch;
  final String? time;
  final String? tempC;
  final String? tempF;
  final String? isDay;
  final Condition? condition;
  final String? windMph;
  final String? windKph;
  final String? windDegree;
  final String? windDir;
  final String? pressureMb;
  final String? pressureIn;
  final String? precipMm;
  final String? precipIn;
  final String? humidity;
  final String? cloud;
  final String? feelslikeC;
  final String? feelslikeF;
  final String? windchillC;
  final String? windchillF;
  final String? heatindexC;
  final String? heatindexF;
  final String? dewpointC;
  final String? dewpointF;
  final String? willItRain;
  final String? chanceOfRain;
  final String? willItSnow;
  final String? chanceOfSnow;
  final String? visKm;
  final String? visMiles;
  final String? gustMph;
  final String? gustKph;
  final String? uv;

  factory Hour.fromJson(Map<String, dynamic> json) => Hour(
        timeEpoch: json["time_epoch"].toString(),
        time: json["time"].toString(),
        tempC: json["temp_c"].toString(),
        tempF: json["temp_f"].toString(),
        isDay: json["is_day"].toString(),
        condition: json["condition"] == null ? null : Condition.fromJson(json["condition"]),
        windMph: json["wind_mph"].toString(),
        windKph: json["wind_kph"].toString(),
        windDegree: json["wind_degree"].toString(),
        windDir: json["wind_dir"].toString(),
        pressureMb: json["pressure_mb"].toString(),
        pressureIn: json["pressure_in"].toString(),
        precipMm: json["precip_mm"].toString(),
        precipIn: json["precip_in"].toString(),
        humidity: json["humidity"].toString(),
        cloud: json["cloud"].toString(),
        feelslikeC: json["feelslike_c"].toString(),
        feelslikeF: json["feelslike_f"].toString(),
        windchillC: json["windchill_c"].toString(),
        windchillF: json["windchill_f"].toString(),
        heatindexC: json["heatindex_c"].toString(),
        heatindexF: json["heatindex_f"].toString(),
        dewpointC: json["dewpoint_c"].toString(),
        dewpointF: json["dewpoint_f"].toString(),
        willItRain: json["will_it_rain"].toString(),
        chanceOfRain: json["chance_of_rain"].toString(),
        willItSnow: json["will_it_snow"].toString(),
        chanceOfSnow: json["chance_of_snow"].toString(),
        visKm: json["vis_km"].toString(),
        visMiles: json["vis_miles"].toString(),
        gustMph: json["gust_mph"].toString(),
        gustKph: json["gust_kph"].toString(),
        uv: json["uv"].toString(),
      );
}
