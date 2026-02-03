class DynamicCarouselModel {
  final int id;
  final String image;

  DynamicCarouselModel({required this.id, required this.image});

  factory DynamicCarouselModel.fromJson(Map<String, dynamic> json) {
    return DynamicCarouselModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  factory DynamicCarouselModel.empty() {
    return DynamicCarouselModel(id: 0, image: '');
  }
}
