class UploadModel {
  String? message;
  String? fileUrl;
  String? publicId;

  UploadModel({this.message, this.fileUrl, this.publicId});

  UploadModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    fileUrl = json['file_url'];
    publicId = json['public_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data= new Map<String, dynamic>();
    data['message'] = message;
    data['file_url'] = fileUrl;
    data['public_id'] = publicId;
    return data;
  }
}
