
import 'package:e_com_user/general/utils/enums/return_status.dart';

class ReturnDetails {
  final String reason;
  final ReturnStatus status;
  final DateTime requestedAt;
  final String? adminNotes;

  const ReturnDetails({
    required this.reason,
    required this.status,
    required this.requestedAt,
    this.adminNotes,
  });

  factory ReturnDetails.fromMap(Map<String, dynamic> map) {
    return ReturnDetails(
      reason: map['reason'] ?? '',
      status: ReturnStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => ReturnStatus.none,
      ),
      requestedAt: map['requestedAt'] != null 
          ? DateTime.parse(map['requestedAt']) 
          : DateTime.now(),
      adminNotes: map['adminNotes'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reason': reason,
      'status': status.name,
      'requestedAt': requestedAt.toIso8601String(),
      if (adminNotes != null) 'adminNotes': adminNotes,
    };
  }
}