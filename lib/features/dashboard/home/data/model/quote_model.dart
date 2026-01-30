class QuoteModel {
  final int id;
  final String quote;
  final String backgroundImage;
  final String textColor;

  QuoteModel({
    required this.id,
    required this.quote,
    required this.backgroundImage,
    required this.textColor,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      id: json['id'] ?? 0,
      quote: json['quote'] ?? '',
      backgroundImage: json['background_image'] ?? '',
      textColor: json['text_color'] ?? '#ffffff',
    );
  }

  factory QuoteModel.empty() {
    return QuoteModel(id: 0, quote: '', backgroundImage: '', textColor: '');
  }
}
