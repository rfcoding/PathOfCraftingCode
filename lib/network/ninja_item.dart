class NinjaItem {
  String name;
  double chaosValue;

  NinjaItem({this.name, this.chaosValue});

  factory NinjaItem.fromJson(Map<String, dynamic> data) {
    if (data['chaosValue'] == null) {
      return null;
    }
    return NinjaItem(
      name: data['name'],
      chaosValue: data['chaosValue']
    );
  }

  factory NinjaItem.fromCurrencyJson(Map<String, dynamic> data) {
    var receive = data['receive'];
    if (receive == null) {
      return null;
    }
    return NinjaItem(
        name: data['currencyTypeName'],
        chaosValue: receive != null ? receive['value'] : 0
    );
  }
}

class NinjaArmour {
  String name;
  double chaosValue;
  int links;

  NinjaArmour(String name, double chaosValue, int links) {
    this.name = name;
    this.chaosValue = chaosValue;
    this.links = links;
  }

  factory NinjaArmour.fromJson(Map<String, dynamic> data) {
    if (data['chaosValue'] == null) {
      return null;
    }
    return NinjaArmour(
        data['name'],
        data['chaosValue'],
        data['links']
    );
  }
}

class NinjaSixLink extends NinjaArmour {
  double chaosProfit;
  
  NinjaSixLink(String name, double chaosValue, double chaosProfit) : super(name, chaosValue, 6) {
    this.chaosProfit = chaosProfit;
  }
}