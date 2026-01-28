class QuoteModel {
  final int id;
  final String quote;
  final String backgroundImage;

  QuoteModel({
    required this.id,
    required this.quote,
    required this.backgroundImage,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] ?? 0,
      quote: json['quote'] ?? '',
      backgroundImage: json['background_image'] ?? '',
    );
  }

  factory QuoteModel.empty() {
    return QuoteModel(id: 0, quote: '', backgroundImage: '');
  }
}
