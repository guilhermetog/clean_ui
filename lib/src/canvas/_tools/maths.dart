import 'dart:math';

double mapValue(
    double x, double inMin, double inMax, double outMin, double outMax) {
  return ((x - inMin) * (outMax - outMin)) / (inMax - inMin) + outMin;
}

T random<T extends num>(T lowerLimit, T upperLimit) {
  if (lowerLimit is int && upperLimit is int) {
    return (Random().nextInt(upperLimit - lowerLimit + 1) + lowerLimit) as T;
  } else if (lowerLimit is double && upperLimit is double) {
    return (Random().nextDouble() * (upperLimit - lowerLimit) + lowerLimit)
        as T;
  }
  throw ArgumentError(
      'Both limits must be of the same numeric type (int or double).');
}

bool randomBool() {
  return Random().nextBool();
}

double distance(double x1, double y1, double x2, double y2) {
  return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
}
