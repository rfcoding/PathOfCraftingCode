class Essence implements Comparable<Essence>{
  int level;
  Map<String, dynamic> mods;
  String name;

  Essence({
    this.level,
    this.mods,
    this.name
  });

  factory Essence.fromJson(Map<String, dynamic> json) {
    return Essence(
      level: json['level'],
      mods: json['mods'],
      name: json['name'],
    );
  }

  String getModForItemClass(String itemClass) {
    return mods[itemClass] as String;
  }

  @override
  int compareTo(Essence other) {
    return other.level - level;
  }
}