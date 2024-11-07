class PetResponseModel {
  PetResponseModel({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
  });

  factory PetResponseModel.fromJson(Map<String, dynamic> json) {
    return PetResponseModel(
      id: json['id'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String,
    );
  }

  final int id;
  final String name;
  final String type;
  final String imageUrl;
}
