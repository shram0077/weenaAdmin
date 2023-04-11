import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  String id;
  String postId;
  String reportedBy;
  String messageReport;
  Timestamp timestamp;

  ReportModel(
      {required this.postId,
      required this.reportedBy,
      required this.timestamp,
      required this.id,
      required this.messageReport});

  factory ReportModel.fromDoc(DocumentSnapshot doc) {
    return ReportModel(
        id: doc.id,
        timestamp: doc['Timestamp'],
        reportedBy: doc['reportedBy'],
        postId: doc['postId'],
        messageReport: doc['messageReport']);
  }
}
