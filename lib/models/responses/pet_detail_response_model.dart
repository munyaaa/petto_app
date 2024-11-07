class PetDetailResponseModel {
  PetDetailResponseModel({
    required this.id,
    required this.name,
    required this.type,
    required this.age,
    required this.weight,
    required this.imageUrl,
  });

  factory PetDetailResponseModel.fromJson(Map<String, dynamic> json) {
    return PetDetailResponseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      age: json['age'] as int,
      weight: json['weight'] as num,
      imageUrl: json['image_url'] as String,
    );
  }

  final int id;
  final String name;
  final String type;
  final int age;
  final num weight;
  final String imageUrl;
}
