enum CommunityMissionStatus { pending, completed, notJoined }

CommunityMissionStatus statusFromDb(String value) {
  switch (value) {
    case 'TRUE':
      return CommunityMissionStatus.completed;
    case 'PENDING':
      return CommunityMissionStatus.pending;
    default:
      return CommunityMissionStatus.notJoined;
  }
}
