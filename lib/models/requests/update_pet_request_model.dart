class UpdatePetRequestModel {
  UpdatePetRequestModel({
    required this.name,
    required this.age,
    required this.weight,
  });

  final String name;
  final int age;
  final num weight;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'weight': weight,
    };
  }
}
