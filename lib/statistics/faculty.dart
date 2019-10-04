
import 'dart:math';

class Faculty {
  int value;

  Faculty(int value) {
    this.value = value;
  }

  double operator/(Faculty other) {
    int low = min(value, other.value);
    int high = max(value, other.value);

    int product = 1;
    for (int i = high; i > low; i--) {
      product *= i;
    }
    if (value < other.value) {
      return 1/product;
    }
    return product.toDouble();
  }

  int calculateValue() {
    int product = 1;
    for(int i = value; i > 0; i--) {
      product *= i;
    }
    return product;
  }

}