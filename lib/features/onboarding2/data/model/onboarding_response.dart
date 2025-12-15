import 'dart:convert';

class OnboardingResponse {
  List<DataContent>? facility;

  OnboardingResponse({
    this.facility,
  });

  OnboardingResponse.fromJson(Map<String, dynamic> json) {
    print(json['data']);
    facility = List<DataContent>.from(
        json['data'].map((e) => DataContent.fromJson(e)));
  }
  OnboardingResponse.fromString(Map<String, dynamic> json) {

    facility = List<DataContent>.from(
        json['data'].map((e) => DataContent.fromString(e)));
  }
  Map<String, dynamic> toJson()=>{

    "data":facility!.map((v) => v.toJson()).toList()
  };

  static Map<String, dynamic> toMap(OnboardingResponse model) {
    return model.toJson();
  }

  static String serialize(OnboardingResponse model) {

    return json.encode(OnboardingResponse.toMap(model));
  }
  static OnboardingResponse deserialize(String? json) {
    return OnboardingResponse.fromString(json!.isNotEmpty ? jsonDecode(json) : {});
  }

}


class DataContent {

  List<String>? goals;
  String? username;
  String? tech;
  List<String>? tools;
  String? avatar;



  DataContent(
      {
        this.goals,
        this.username,
        this.tech,
        this.tools,
        this.avatar,

        });

  DataContent.fromJson(Map<String, dynamic> json) {


    if (json['goals'] != null) {
      goals = json['goals'];
    }
    if (json['username'] != null) {
      username = json['username'];
    }

    if (json['tech'] != null) {
      tech = json['tech'];
    }
    if (json['tools'] != null) {
      tools = json['tools'];
    }
    if (json['avatar'] != null) {
      avatar = json['avatar'];
    }
  }
  DataContent.fromString(Map<String, dynamic> json) {


    if (json['goals'] != null) {
      goals = json['goals'];
    }
    if (json['username'] != null) {
      username = json['username'];
    }
    if (json['tech'] != null) {
      tech = json['tech'];
    }
    if (json['tools'] != null) {
      tools = json['tools'];
    }
    if (json['avatar'] != null) {
      avatar = json['avatar'];
    }


  }

  Map<String, dynamic> toJson() {
    return {
      'goals': goals,
      'username': username,
      'tech': tech,
      'tools': tools,
      'avatar': avatar,

    };
  }
}