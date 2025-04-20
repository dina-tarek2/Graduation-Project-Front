class UploadedDicom {
    UploadedDicom({
        required this.message,
        required this.data,
    });

    final String? message;
    final List<Datum> data;

    factory UploadedDicom.fromJson(Map<String, dynamic> json){ 
        return UploadedDicom(
            message: json["message"],
            data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        );
    }

}

class Datum {
    Datum({
        required this.address,
        required this.operatingHours,
        required this.emergencyContact,
        required this.recordsCountPerDay,
        required this.centerName,
        required this.contactNumber,
        required this.email,
        required this.passwordHash,
        required this.path,
        required this.image,
        required this.isApproved,
        required this.facilities,
        required this.certifications,
        required this.createdAt,
        required this.updatedAt,
        required this.id,
    });

    final Address? address;
    final OperatingHours? operatingHours;
    final EmergencyContact? emergencyContact;
    final RecordsCountPerDay? recordsCountPerDay;
    final String? centerName;
    final String? contactNumber;
    final String? email;
    final String? passwordHash;
    final String? path;
    final String? image;
    final bool? isApproved;
    final List<dynamic> facilities;
    final List<dynamic> certifications;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final String? id;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            operatingHours: json["operatingHours"] == null ? null : OperatingHours.fromJson(json["operatingHours"]),
            emergencyContact: json["emergencyContact"] == null ? null : EmergencyContact.fromJson(json["emergencyContact"]),
            recordsCountPerDay: json["recordsCountPerDay"] == null ? null : RecordsCountPerDay.fromJson(json["recordsCountPerDay"]),
            centerName: json["centerName"],
            contactNumber: json["contactNumber"],
            email: json["email"],
            passwordHash: json["passwordHash"],
            path: json["path"],
            image: json["image"],
            isApproved: json["isApproved"],
            facilities: json["facilities"] == null ? [] : List<dynamic>.from(json["facilities"]!.map((x) => x)),
            certifications: json["certifications"] == null ? [] : List<dynamic>.from(json["certifications"]!.map((x) => x)),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            id: json["id"],
        );
    }

}

class Address {
    Address({
        required this.street,
        required this.city,
        required this.state,
        required this.zipCode,
    });

    final String? street;
    final String? city;
    final String? state;
    final String? zipCode;

    factory Address.fromJson(Map<String, dynamic> json){ 
        return Address(
            street: json["street"],
            city: json["city"],
            state: json["state"],
            zipCode: json["zipCode"],
        );
    }

}

class EmergencyContact {
    EmergencyContact({
        required this.available24X7,
    });

    final bool? available24X7;

    factory EmergencyContact.fromJson(Map<String, dynamic> json){ 
        return EmergencyContact(
            available24X7: json["available24x7"],
        );
    }

}

class OperatingHours {
    OperatingHours({
        required this.holidays,
    });

    final List<dynamic> holidays;

    factory OperatingHours.fromJson(Map<String, dynamic> json){ 
        return OperatingHours(
            holidays: json["holidays"] == null ? [] : List<dynamic>.from(json["holidays"]!.map((x) => x)),
        );
    }

}

class RecordsCountPerDay {
    RecordsCountPerDay({required this.json});
    final Map<String,dynamic> json;

    factory RecordsCountPerDay.fromJson(Map<String, dynamic> json){ 
        return RecordsCountPerDay(
        json: json
        );
    }

}
