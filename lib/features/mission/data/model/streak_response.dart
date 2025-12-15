class StreakResponse{
  StreakResponse({
    this.id,
    this.userId,
    this.currentStreak

});
  int? id;
  String? userId;
  int? currentStreak;
  StreakResponse.fromJson(Map<String,dynamic>json){

    print(json['id']);
    print(id);
    if(json['id']!=null){
      id=json['id'];
    }
    if(json['user_id']!=null){
      userId=json['user_id'];
    }
    if(json['current_streak']!=null){
      currentStreak=json['current_streak'];
    }
  }
}