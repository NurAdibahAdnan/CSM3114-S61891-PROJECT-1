class Lab {
  final String name;
  final int capacity;
  final String desc;
  bool isAvailable;

  Lab({
    required this.name,
    required this.capacity,
    required this.desc,
    this.isAvailable = true,
  });

  void updateAvailability(bool newStatus) {
    isAvailable = newStatus;
  }
}

Map<String, String> labImagePaths = {
  'lab1': 'lab 1_image.png',
  'lab2': 'lab 2_image.png',
  'lab3': 'lab 3_image.png',
  'lab4': 'lab cisco_image.png',
};