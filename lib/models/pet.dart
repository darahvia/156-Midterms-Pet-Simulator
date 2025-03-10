class Pet {
  String name;
  double hunger;
  double energy;
  double hygiene;

  Pet({
    required this.name,
    this.hunger = 10,
    this.energy = 100,
    this.hygiene = 10,
  });
}
