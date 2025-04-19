class ApprovedCentersModel {
    ApprovedCentersModel({
        required this.message,
        required this.data,
    });

    final String? message;
    final List<Datum> data;

    factory ApprovedCentersModel.fromJson(Map<String, dynamic> json){ 
        return ApprovedCentersModel(
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
        required this.image,
        required this.recordsCountPerDay,
        required this.centerName,
        required this.contactNumber,
        required this.email,
        required this.passwordHash,
        required this.path,
        required this.facilities,
        required this.certifications,
        required this.createdAt,
        required this.updatedAt,
        required this.isApproved,
        required this.id,
        required this.website,
    });

    final Address? address;
    final OperatingHours? operatingHours;
    final EmergencyContact? emergencyContact;
    final String? image;
    final RecordsCountPerDay? recordsCountPerDay;
    final String? centerName;
    final String? contactNumber;
    final String? email;
    final String? passwordHash;
    final String? path;
    final List<Facility> facilities;
    final List<Certification> certifications;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final bool? isApproved;
    final String? id;
    final String? website;

    factory Datum.fromJson(Map<String, dynamic> json){ 
        return Datum(
            address: json["address"] == null ? null : Address.fromJson(json["address"]),
            operatingHours: json["operatingHours"] == null ? null : OperatingHours.fromJson(json["operatingHours"]),
            emergencyContact: json["emergencyContact"] == null ? null : EmergencyContact.fromJson(json["emergencyContact"]),
            image: json["image"],
            recordsCountPerDay: json["recordsCountPerDay"] == null ? null : RecordsCountPerDay.fromJson(json["recordsCountPerDay"]),
            centerName: json["centerName"],
            contactNumber: json["contactNumber"],
            email: json["email"],
            passwordHash: json["passwordHash"],
            path: json["path"],
            facilities: json["facilities"] == null ? [] : List<Facility>.from(json["facilities"]!.map((x) => Facility.fromJson(x))),
            certifications: json["certifications"] == null ? [] : List<Certification>.from(json["certifications"]!.map((x) => Certification.fromJson(x))),
            createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
            updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
            isApproved: json["isApproved"],
            id: json["id"],
            website: json["website"],
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

class Certification {
    Certification({
        required this.name,
        required this.issuedBy,
        required this.issueDate,
        required this.expiryDate,
        required this.status,
        required this.id,
    });

    final String? name;
    final String? issuedBy;
    final DateTime? issueDate;
    final DateTime? expiryDate;
    final String? status;
    final String? id;

    factory Certification.fromJson(Map<String, dynamic> json){ 
        return Certification(
            name: json["name"],
            issuedBy: json["issuedBy"],
            issueDate: DateTime.tryParse(json["issueDate"] ?? ""),
            expiryDate: DateTime.tryParse(json["expiryDate"] ?? ""),
            status: json["status"],
            id: json["_id"],
        );
    }

}

class EmergencyContact {
    EmergencyContact({
        required this.available24X7,
        required this.name,
        required this.number,
    });

    final bool? available24X7;
    final String? name;
    final String? number;

    factory EmergencyContact.fromJson(Map<String, dynamic> json){ 
        return EmergencyContact(
            available24X7: json["available24x7"],
            name: json["name"],
            number: json["number"],
        );
    }

}

class Facility {
    Facility({
        required this.name,
        required this.description,
        required this.status,
        required this.id,
    });

    final String? name;
    final String? description;
    final String? status;
    final String? id;

    factory Facility.fromJson(Map<String, dynamic> json){ 
        return Facility(
            name: json["name"],
            description: json["description"],
            status: json["status"],
            id: json["_id"],
        );
    }

}

class OperatingHours {
    OperatingHours({
        required this.holidays,
        required this.weekdays,
        required this.weekends,
    });

    final List<Holiday> holidays;
    final Week? weekdays;
    final Week? weekends;

    factory OperatingHours.fromJson(Map<String, dynamic> json){ 
        return OperatingHours(
            holidays: json["holidays"] == null ? [] : List<Holiday>.from(json["holidays"]!.map((x) => Holiday.fromJson(x))),
            weekdays: json["weekdays"] == null ? null : Week.fromJson(json["weekdays"]),
            weekends: json["weekends"] == null ? null : Week.fromJson(json["weekends"]),
        );
    }

}

class Holiday {
    Holiday({
        required this.date,
        required this.description,
        required this.isOpen,
        required this.id,
    });

    final DateTime? date;
    final String? description;
    final bool? isOpen;
    final String? id;

    factory Holiday.fromJson(Map<String, dynamic> json){ 
        return Holiday(
            date: DateTime.tryParse(json["date"] ?? ""),
            description: json["description"],
            isOpen: json["isOpen"],
            id: json["_id"],
        );
    }

}

class Week {
    Week({
        required this.open,
        required this.close,
    });

    final String? open;
    final String? close;

    factory Week.fromJson(Map<String, dynamic> json){ 
        return Week(
            open: json["open"],
            close: json["close"],
        );
    }

}

class RecordsCountPerDay {
    RecordsCountPerDay({
        required this.count,
    });

    final int? count;

    factory RecordsCountPerDay.fromJson(Map<String, dynamic> json){ 
        return RecordsCountPerDay(
            count: json["2025-04-14"],
        );
    }

}
