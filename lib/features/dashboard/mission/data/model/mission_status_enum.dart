enum MissionStatus { pending, completed, rejected, notJoined }

MissionStatus statusFromDb(String value) {
  switch (value) {
    case 'TRUE':
    case 'APPROVED':
      return MissionStatus.completed;
    case 'PENDING':
      return MissionStatus.pending;
    case 'FALSE':
    case 'REJECTED':
      return MissionStatus.rejected;
    default:
      return MissionStatus.notJoined;
  }
}
