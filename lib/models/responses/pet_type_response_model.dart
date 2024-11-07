class PetTypeResponseModel {
  PetTypeResponseModel({
    required this.id,
    required this.type,
    required this.imageUrl,
  });

  final int id;
  final String type;
  final String imageUrl;

  factory PetTypeResponseModel.fromJson(Map<String, dynamic> json) {
    return PetTypeResponseModel(
      id: json['id'] as int,
      type: json['type'] as String,
      imageUrl: json['image_url'] as String,
    );
  }
}
