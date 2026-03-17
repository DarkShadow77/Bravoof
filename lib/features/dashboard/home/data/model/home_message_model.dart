import '../../../mission/data/model/featured_mission_model.dart';

class HomeMessageModel {
  final int id;
  final String title;
  final String message;
  final MissionGradient gradientColor;
  final String textColor;
  final String mainTextColor;

  HomeMessageModel({
    required this.id,
    required this.title,
    required this.message,
    required this.gradientColor,
    required this.textColor,
    required this.mainTextColor,
  });

  factory HomeMessageModel.fromJson(Map<String, dynamic> json) {
    return HomeMessageModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      gradientColor: MissionGradient.fromJson(json['gradient_color']),
      textColor: json['text_color'] ?? '#000000',
      mainTextColor: json['main_text_color'] ?? '#000000',
    );
  }

  factory HomeMessageModel.empty() {
    return HomeMessageModel(
      id: 0,
      title: '',
      message: '',
      gradientColor: MissionGradient.fallback(),
      textColor: '#000000',
      mainTextColor: '#000000',
    );
  }
}
