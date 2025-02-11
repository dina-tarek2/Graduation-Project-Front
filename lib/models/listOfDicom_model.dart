class DicomFile {
  final String name;
  final String id;

  DicomFile({required this.name, required this.id});

  factory DicomFile.fromJson(Map<String, dynamic> json) {
    return DicomFile(
      name: json['name'],
      id: json['id'],
    );
  }
}

class DicomResponse {
  final int count;
  final List<DicomFile> files;

  DicomResponse({required this.count, required this.files});

  factory DicomResponse.fromJson(List<dynamic> json) {
    final count = json[0]['count']; 
    final List<DicomFile> files =
        (json[1] as List).map((file) => DicomFile.fromJson(file)).toList();
    return DicomResponse(count: count, files: files);
  }
}
