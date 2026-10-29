
class RegistrationTicket {
  final String id;
  final String eventId;
  final String eventTitle;
  final String participantName;
  final String nim;
  final String email;
  final String whatsapp;
  final String participantType;
  final DateTime attendanceDate;
  final bool withKit;
  final double donation;

  const RegistrationTicket({
    required this.id,
    required this.eventId,
    required this.eventTitle,
    required this.participantName,
    required this.nim,
    required this.email,
    required this.whatsapp,
    required this.participantType,
    required this.attendanceDate,
    required this.withKit,
    required this.donation,
  });
}
