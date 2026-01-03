enum MissionStatus { pending, completed, rejected, notJoined }

MissionStatus statusFromDb(String value) {
  switch (value) {
    case 'TRUE':
      return MissionStatus.completed;
    case 'PENDING':
      return MissionStatus.pending;
    case 'FALSE':
      return MissionStatus.rejected;
    default:
      return MissionStatus.notJoined;
  }
}
