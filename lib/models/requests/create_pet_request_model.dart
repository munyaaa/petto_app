class CreatePetRequestModel {
  CreatePetRequestModel({
    required this.typeId,
    required this.name,
    required this.age,
    required this.weight,
  });

  final int typeId;
  final String name;
  final int age;
  final num weight;

  Map<String, dynamic> toJson() {
    return {
      'type_id': typeId,
      'name': name,
      'age': age,
      'weight': weight,
    };
  }
}
