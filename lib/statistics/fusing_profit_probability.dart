
import 'package:poe_clicker/statistics/probability.dart';

class FusingProfitProbability {
  double pi = 0.001;

  double profitProbability(int fusingsUsed, int sixLinksNeeded) {
    if (fusingsUsed < sixLinksNeeded) {
      return 0;
    }
    Probability probability = Probability(fusingsUsed, pi);
    double chanceToWin = 1;
    for (int x = sixLinksNeeded - 1; x >= 0; x--) {
      chanceToWin -= probability.P(x);
    }
    return chanceToWin;
  }

  double numberOfLinksProbabilityInPercent(int fusingsUsed, int sixLinks) {
    Probability probability = Probability(fusingsUsed, pi);
    return probability.P(sixLinks) * 100;
  }
}