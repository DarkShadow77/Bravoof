class DynamicCarouselModel {
  final int id;
  final String image;
  final String destination;

  DynamicCarouselModel({
    required this.id,
    required this.image,
    required this.destination,
  });

  factory DynamicCarouselModel.fromJson(Map<String, dynamic> json) {
    return DynamicCarouselModel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      destination: json['destination'] ?? '',
    );
  }

  factory DynamicCarouselModel.empty() {
    return DynamicCarouselModel(id: 0, image: '', destination: '');
  }
}
