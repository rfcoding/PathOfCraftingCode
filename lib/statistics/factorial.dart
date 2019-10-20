
import 'dart:math';

import 'fraction.dart';

class Factorial {
  int value;

  Factorial(int value) {
    this.value = value;
  }

  List<Fraction> operator/(Factorial other) {
    List<int> multipliers = List();
    int low = min(value, other.value);
    int high = max(value, other.value);
    for (int i = high; i > low; i--) {
      multipliers.add(i);
    }

    if (value > other.value) {
      return numerators(multipliers);
    }
    return denominator(multipliers);
  }

  List<Fraction> numerators(List<int> numerators) {
    return numerators.map((numerator) => Fraction(numerator.toDouble(), 1)).toList();
  }
  List<Fraction> denominator(List<int> denominators) {
    return denominators.map((denominator) => Fraction(1, denominator.toDouble())).toList();
  }

  int calculateValue() {
    int product = 1;
    for(int i = value; i > 0; i--) {
      product *= i;
    }
    return product;
  }

  List<Fraction> toFraction(bool numerator) {
    List<Fraction> result = List();
    for(int i = value; i > 0; i--) {
      if (numerator) {
        result.add(Fraction(i.toDouble(), 1));
      } else {
        result.add(Fraction(1, i.toDouble()));
      }
    }
    return result;
  }

}