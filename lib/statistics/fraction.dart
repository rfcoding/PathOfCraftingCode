
class Fraction extends Comparable<Fraction>{
  final double numerator;
  final double denominator;

  Fraction(this.numerator, this.denominator);

  bool greaterThanOne() {
    return numerator > denominator;
  }

  double operator*(Fraction other) {
    return this.numerator * other.numerator / (this.denominator * other.denominator);
  }

  double value() {
    return numerator / denominator;
  }

  @override
  int compareTo(Fraction other) {
    double val = value() - other.value();
    if (val == 0) {
      return 0;
    } else if (val > 0) {
      return 1;
    }
    return -1;
  }

  static double multiplyFractions(List<Fraction> fractions) {
    fractions.sort((a, b) => a.compareTo(b));
    double result = fractions.removeLast().value();

    while (fractions.isNotEmpty) {
      if (result < 1) {
        result = fractions.removeLast().value() * result;
      } else {
        result = fractions.removeAt(0).value() * result;
      }
    }
    return result;
  }
}