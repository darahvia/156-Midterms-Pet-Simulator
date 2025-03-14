

class Pet {
  String name;
  double hunger;
  double energy;
  double hygiene;
  double happiness;
  int coins;
  DateTime lastUpdated;

  //pet stats
  Pet({
    required this.name,
    this.hunger = 100,
    this.energy = 100,
    this.hygiene = 100,
    this.happiness = 100,
    this.coins = 0,
    DateTime? lastUpdated
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  void decreaseStats() {
    hunger = (hunger - 10).clamp(0.0, 100.0);
    hygiene = (hygiene - 5).clamp(0.0, 100.0);
    energy = (energy + 10).clamp(0.0, 100.0);
    happiness = (happiness - 5).clamp(0.0, 100.0);
    lastUpdated = DateTime.now();
  }

  void applyElapsedTime() {
    final now = DateTime.now();
    final elapsedSeconds = now.difference(lastUpdated).inSeconds;

    if (elapsedSeconds > 0) {
      final decreaseAmount = (elapsedSeconds / 5).floor();
      hunger = (hunger - (decreaseAmount * 10)).clamp(0, 100);
      hygiene = (hygiene - (decreaseAmount * 5)).clamp(0, 100);
      energy = (energy + (decreaseAmount * 10)).clamp(0, 100);
      happiness = (happiness - (decreaseAmount * 5)).clamp(0, 100);
      lastUpdated = now;
    }
  }

  void updateLastUpdated() {
    lastUpdated = DateTime.now();
  }

  void printStats(String action) {
    print('$action - Hunger: $hunger, Hygiene: $hygiene, Happiness: $happiness, Energy: $energy');
  }

}
