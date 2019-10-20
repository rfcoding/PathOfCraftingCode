
import 'dart:math';

import 'package:poe_clicker/statistics/factorial.dart';

import 'fraction.dart';

class Probability {
  int N; // Number of trials
  double pi; // Chance of success
  Map<int, double> cache = Map();
  Probability(int N, double pi) {
    this.N = N;
    this.pi = pi;
  }

  double P(int x) { // Probability of x successes over N trials with pi success chance
    // http://onlinestatbook.com/2/probability/binomial.html

    if (cache.containsKey(x)) {
      print("Using cache for $x");
      return cache[x];
    }

    assert(x <= N, "x has to be smaller than or equal to N");
    Factorial facN = Factorial(N);
    Factorial facX = Factorial(x);
    int nx = N - x;
    Factorial facNx = Factorial(N - x);
    Factorial divFac;
    List<Fraction> fractions;
    if (nx > x) {
      divFac = facNx;
      fractions = facX.toFraction(false);
    } else {
      divFac = facX;
      fractions = facNx.toFraction(false);
    }
    fractions.addAll(facN / divFac);

    fractions.add(Fraction(pow(pi, x), 1));
    fractions.add(Fraction(pow(1 - pi, N - x), 1));

    double probability = Fraction.multiplyFractions(fractions);
    cache[x] = probability;
    return probability;
  }
}