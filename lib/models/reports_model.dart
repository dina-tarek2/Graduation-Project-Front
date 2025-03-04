// class ReportsResponse {
//   final int numOfAIReports;
//   final List<Report> reports;

//   ReportsResponse({
//     required this.numOfAIReports,
//     required this.reports,
//   });
// }
  class ReportsResponse {  
  final List<Report> reports;  
   final int? numOfAIReports;
  ReportsResponse({required this.reports,this.numOfAIReports});  

  factory ReportsResponse.fromJson(Map<String, dynamic> json) { 
    print('Parsing JSON: $json');  
    var list = json['reports'] as List; 
    List<Report> reportsList = list.map((i) => Report.fromJson(i)).toList();  
    
    return ReportsResponse( numOfAIReports: json['numOfAIReports'] ?? 0,
    reports: (json['reports'] as List<dynamic>?)
            ?.map((e) => Report.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );  
  }  
}

class Report {
  final String id;
  final String recordId;
  final String diagnosisReport;
  final String result;
  final String status;
  final int confidenceLevel;
  final DateTime generatedDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  String? patientName; // Will be populated from second API

  Report({
    required this.id,
    required this.recordId,
    required this.diagnosisReport,
    required this.result,
    required this.status,
    required this.confidenceLevel,
    required this.generatedDate,
    required this.createdAt,
    required this.updatedAt,
    this.patientName,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['_id'],
      recordId: json['record'],
      diagnosisReport: json['diagnosisReport'],
      result: json['result'],
      status: json['status'],
      confidenceLevel: json['confidenceLevel'],
      generatedDate: DateTime.parse(json['generatedDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}