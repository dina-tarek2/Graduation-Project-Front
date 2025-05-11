class DocotorsModel {
    DocotorsModel({
        required this.message,
        required this.data,
    });

    final String? message;
    final List<Datum> data;

    factory DocotorsModel.fromJson(Map<String, dynamic> json){ 
        return DocotorsModel(
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.numberOfReports,
        required this.id,
        required this.firstName,
        required this.lastName,
        required this.specialization,
        required this.contactNumber,
        required this.status,
        required this.email,
        required this.passwordHash,
        required this.image,
        required this.experience,
        required this.createdAt,
        required this.updatedAt,
        required this.v,
        required this.frontId,
        required this.backId,
        required this.walletId,
        required this.walletBalance,
    });

    final NumberOfReports? numberOfReports;
    final String? id;
    final String? firstName;
    final String? lastName;
    final List<String> specialization;
    final String? contactNumber;
    final String? status;
    final String? email;
    final String? passwordHash;
    final String? image;
    final int? experience;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final int? v;
    final String? frontId;
    final String? backId;
    final String? walletId;
    final int? walletBalance;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            numberOfReports: json["numberOfReports"] == null ? null : NumberOfReports.fromJson(json["numberOfReports"]),
            id: json["_id"],
            firstName: json["firstName"],
            lastName: json["lastName"],
            specialization: json["specialization"] == null ? [] : List<String>.from(json["specialization"]!.map((x) => x)),
            contactNumber: json["contactNumber"],
            status: json["status"],
            email: json["email"],
            passwordHash: json["passwordHash"],
            image: json["image"],
            experience: json["experience"],
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            v: json["__v"],
            frontId: json["frontId"],
            backId: json["backId"],
            walletId: json["walletId"],
            walletBalance: json["walletBalance"],
        );
    }

}

class NumberOfReports {
    NumberOfReports({
        required this.chestRadiology,
        required this.abdominalRadiology,
        required this.headAndNeckRadiology,
        required this.musculoskeletalRadiology,
        required this.neuroradiology,
        required this.thoracicRadiology,
        required this.cardiovascularRadiology,
        required this.numberOfReportsChestRadiology,
        required this.numberOfReportsAbdominalRadiology,
        required this.headandNeckRadiology,
        required this.numberOfReportsMusculoskeletalRadiology,
        required this.numberOfReportsThoracicRadiology,
        required this.numberOfReportsCardiovascularRadiology,
    });

    final List<DateTime> chestRadiology;
    final List<dynamic> abdominalRadiology;
    final List<dynamic> headAndNeckRadiology;
    final List<dynamic> musculoskeletalRadiology;
    final List<DateTime> neuroradiology;
    final List<dynamic> thoracicRadiology;
    final List<dynamic> cardiovascularRadiology;
    final int? numberOfReportsChestRadiology;
    final int? numberOfReportsAbdominalRadiology;
    final int? headandNeckRadiology;
    final int? numberOfReportsMusculoskeletalRadiology;
    final int? numberOfReportsThoracicRadiology;
    final int? numberOfReportsCardiovascularRadiology;

    factory NumberOfReports.fromJson(Map<String, dynamic> json){ 
        return NumberOfReports(
            chestRadiology: json["Chest Radiology"] == null ? [] : List<DateTime>.from(json["Chest Radiology"]!.map((x) => DateTime.tryParse(x ?? ""))),
            abdominalRadiology: json["Abdominal Radiology"] == null ? [] : List<dynamic>.from(json["Abdominal Radiology"]!.map((x) => x)),
            headAndNeckRadiology: json["Head and Neck Radiology"] == null ? [] : List<dynamic>.from(json["Head and Neck Radiology"]!.map((x) => x)),
            musculoskeletalRadiology: json["Musculoskeletal Radiology"] == null ? [] : List<dynamic>.from(json["Musculoskeletal Radiology"]!.map((x) => x)),
            neuroradiology: json["Neuroradiology"] == null ? [] : List<DateTime>.from(json["Neuroradiology"]!.map((x) => DateTime.tryParse(x ?? ""))),
            thoracicRadiology: json["Thoracic Radiology"] == null ? [] : List<dynamic>.from(json["Thoracic Radiology"]!.map((x) => x)),
            cardiovascularRadiology: json["Cardiovascular Radiology"] == null ? [] : List<dynamic>.from(json["Cardiovascular Radiology"]!.map((x) => x)),
            numberOfReportsChestRadiology: json["ChestRadiology"],
            numberOfReportsAbdominalRadiology: json["AbdominalRadiology"],
            headandNeckRadiology: json["HeadandNeckRadiology"],
            numberOfReportsMusculoskeletalRadiology: json["MusculoskeletalRadiology"],
            numberOfReportsThoracicRadiology: json["ThoracicRadiology"],
            numberOfReportsCardiovascularRadiology: json["CardiovascularRadiology"],
        );
    }

}
