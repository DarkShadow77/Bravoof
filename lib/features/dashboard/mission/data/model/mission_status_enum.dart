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

String statusToDb(MissionStatus status) {
  switch (status) {
    case MissionStatus.pending:
      return 'PENDING';
    case MissionStatus.completed:
      return 'TRUE';
    case MissionStatus.rejected:
      return 'FALSE';
    case MissionStatus.notJoined:
      return 'NOT_JOINED'; // fallback, shouldn't be serialised
  }
}
