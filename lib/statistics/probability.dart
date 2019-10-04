
import 'dart:math';

import 'package:poe_clicker/statistics/faculty.dart';

class Probability {
  int N; // Number of trials
  double pi; // Chance of success
  Probability(int N, double pi) {
    this.N = N;
    this.pi = pi;
  }

  double P(int x) { // Probability of x successes over N trials with pi success chance
    // http://onlinestatbook.com/2/probability/binomial.html
    assert(x <= N, "x has to be smaller than or equal to N");
    Faculty facN = Faculty(N);
    Faculty facX = Faculty(x);
    int nx = N - x;
    Faculty facNx = Faculty(N - x);
    Faculty divFac;
    int divNum;
    if (nx > x) {
      divFac = facNx;
      divNum = facX.calculateValue();
    } else {
      divFac = facX;
      divNum = facNx.calculateValue();
    }
    double division = facN / divFac;
    division = division / divNum;

    double piX = pow(pi, x);
    double oneMinusPiX = pow(1 - pi, N - x);

    return division * piX * oneMinusPiX;
  }
}