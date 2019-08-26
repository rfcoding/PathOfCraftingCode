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
