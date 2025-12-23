enum MissionStatus { pending, completed, notJoined }

MissionStatus statusFromDb(String value) {
  switch (value) {
    case 'TRUE':
      return MissionStatus.completed;
    case 'PENDING':
      return MissionStatus.pending;
    default:
      return MissionStatus.notJoined;
  }
}
