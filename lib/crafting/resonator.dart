
class Resonator {
  static final RESONATORS = [
    Resonator(name: "Primitive Chaotic Resonator", socketCount: 1),
    Resonator(name: "Potent Chaotic Resonator", socketCount: 2),
    Resonator(name: "Powerful Chaotic Resonator", socketCount: 3),
    Resonator(name: "Prime Chaotic Resonator", socketCount: 4),
  ];

  static Resonator getResonatorForSocketCount(int socketCount) {
    return RESONATORS.firstWhere((resonator) => resonator.socketCount == socketCount);
  }

  String name;
  int socketCount;

  Resonator({
    this.name,
    this.socketCount
  });
}