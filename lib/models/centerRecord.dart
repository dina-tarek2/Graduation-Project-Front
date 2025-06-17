class CenterRecord {
  final String centerName;
  final int Completed;
  final int notCompleted;

  CenterRecord({required this.centerName,
   required this.Completed,
    required this.notCompleted});

    factory CenterRecord.fromJson(Map<String,dynamic> json ){
       return CenterRecord(centerName: json['centerName'],
        Completed: json['record_is_completed'], 
        notCompleted: json['record_is_Not_completed']);
    }
}
class DailyStatusCount{
  final String date;
  final Map<String, int> statusCounts;

  DailyStatusCount({required this.date, required this.statusCounts});

  factory DailyStatusCount.fromJson(Map<String, dynamic> json) {
    final statuses = (json['countByStatus'] as Map<String, dynamic>).map(
      (key, value) => MapEntry(key, value as int),
    );
    return DailyStatusCount(
      date: json['date'] ?? '',
      statusCounts: statuses,
    );
  }
}