extension ImageString on String {
  String toImageDataString() {
    // icon : //cdn.weatherapi.com/weather/64x64/day/116.png
    return length > 26 ? substring(35, length) : this;
  }
}