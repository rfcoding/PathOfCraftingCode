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

class NinjaGear {
  String name;
  double chaosValue;
  int links;
  String variant;

  NinjaGear(String name, double chaosValue, int links, String variant) {
    this.name = name;
    this.chaosValue = chaosValue;
    this.links = links;
    this.variant = variant;
  }

  factory NinjaGear.fromJson(Map<String, dynamic> data) {
    if (data['chaosValue'] == null) {
      return null;
    }
    return NinjaGear(
        data['name'],
        data['chaosValue'],
        data['links'],
        data['variant']
    );
  }

  @override
  String toString() {
    return variant != null ? "$name $variant" : name;
  }
}

class NinjaSixLink extends NinjaGear {
  double chaosProfit;
  
  NinjaSixLink(String name, double chaosValue, double chaosProfit, String variant) : super(name, chaosValue, 6, variant) {
    this.chaosProfit = chaosProfit;
  }
}