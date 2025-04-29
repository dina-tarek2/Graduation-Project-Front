import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_profile_cubit.dart';
import 'package:graduation_project_frontend/models/doctors_model.dart';
import 'dart:io';
import 'package:graduation_project_frontend/constants/colors.dart';

class DoctorProfile extends StatefulWidget {
  final String doctorId;
  final String role;
  const DoctorProfile({super.key, required this.doctorId, required this.role});

  @override
  _DoctorProfileState createState() => _DoctorProfileState();
}

class _DoctorProfileState extends State<DoctorProfile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<DoctorProfileCubit>().fetchDoctorProfile(widget.doctorId);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      context
          .read<DoctorProfileCubit>()
          .updateProfileImage(widget.doctorId, pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<DoctorProfileCubit, DoctorProfileState>(
        builder: (context, state) {
          if (state is DoctorProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DoctorProfileSuccess) {
            return _buildDoctorProfile(state.doctor);
          } else if (state is DoctorProfileError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const Center(child: Text("No Data Available"));
        },
      ),
    );
  }

  Widget _buildDoctorProfile(Doctor doctor) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 200,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [blue, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.center,
              ),
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 52,
                        backgroundColor: blue, // لون افتراضي للخلفية
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : (doctor.imageUrl.isNotEmpty
                                ? NetworkImage(doctor.imageUrl) as ImageProvider
                                : null),
                        child: (_imageFile == null && doctor.imageUrl.isEmpty)
                            ? buildName(
                                doctor) // وضع الأحرف الأولى عند عدم وجود صورة
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.flip_camera_ios_rounded,
                            color: darkBabyBlue),
                        onPressed: _showImageSourceDialog,
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    "${doctor.firstName} ${doctor.lastName}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(doctor.email, style: TextStyle(color: grey)),

                  //text file can be copying the user id

                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: doctor.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Copied to clipboard"),
                        ),
                      );
                    },
                    child: Text(
                      "ID: ${doctor.id}",                      
                      style: const TextStyle(
                          color: blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),

                  // const SizedBox(height: 10),
                  // Text("405.50 ج.م",
                  //     style: TextStyle(
                  //         color: blue,
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    _editableInfoRow(Icons.person, "First Name",
                        doctor.firstName, "firstName", doctor),
                    _editableInfoRow(Icons.person, "Last Name", doctor.lastName,
                        "lastName", doctor),
                    _editableInfoRow(Icons.phone, "Phone Number",
                        doctor.contactNumber, "contactNumber", doctor),
                    _editableInfoRow(
                        Icons.medical_services_rounded,
                        "Specialization",
                        doctor.specialization.join(", "),
                        "specialization",
                        doctor),
                    // _infoRow(Icons.assignment, "Number of Reports",
                    //     doctor.numberOfReports.toString(),
                    //     editable: false),
                    _infoRow(
                      doctor.status == "online"
                          ? Icons.check_circle
                          : Icons.cancel,
                      "Status",
                      doctor.status,
                      color:
                          doctor.status == "online" ? Colors.green : Colors.red,
                      editable: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(
    IconData icon,
    String title,
    String value, {
    Color? color,
    bool editable = false,
    VoidCallback? onEdit,
    bool isMultiline = false, // <-- أضفنا ده
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // مهم علشان السطر الطويل يبقى مضبوط
        children: [
          Icon(icon, color: color ?? blue, size: 22),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: !isMultiline && title == "Specialization"
                ? Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: value
                        .split(',')
                        .map((item) => Chip(
                              label: Text(item.trim()),
                              backgroundColor:
                                  const Color.fromARGB(209, 222, 222, 222),
                              labelStyle: TextStyle(
                                color: color ?? Colors.black87,
                                fontSize: 14,
                              ),
                            ))
                        .toList(),
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: color ?? Colors.black87,
                    ),
                  ),
          ),
          if (editable && onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: blue),
              onPressed: onEdit,
            ),
        ],
      ),
    );
  }

  Widget _editableInfoRow(
    IconData icon,
    String title,
    String value,
    String fieldKey,
    Doctor doctor,
  ) {
    if (fieldKey != "specialization") {
      return _infoRow(icon, title, value,
          editable: true,
          isMultiline: true,
          onEdit: () => _showEditDialog(title, value, fieldKey));
    } else {
      return _infoRow(icon, title, value,
          editable: true,
          onEdit: () => _showSpecializationDialog(context, doctor));
    }
  }

  void _showEditDialog(String title, String currentValue, String fieldKey) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context, // ✅ إصلاح الخطأ بتمرير السياق الصحيح
      builder: (BuildContext context) => AlertDialog(
        title: Text("Edit $title"),
        content: TextField(
            controller: controller,
            decoration: const InputDecoration(border: OutlineInputBorder())),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<DoctorProfileCubit>().updateDoctorProfile(
                  widget.doctorId, {
                fieldKey: controller.text
              }); // ✅ إصلاح الخطأ باستخدام widget.doctorId
            },
            child: const Text("Save", style: TextStyle(color: blue)),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context, // ✅ إصلاح الخطأ بتمرير السياق الصحيح
      builder: (BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(
                  ImageSource.camera); // ✅ إصلاح الخطأ باستخدام دالة صحيحة
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(
                  ImageSource.gallery); // ✅ إصلاح الخطأ باستخدام دالة صحيحة
            },
          ),
          ListTile(
              leading: const Icon(Icons.remove_circle_outline,
                  color: Color(0xFFFF0202)),
              title: const Text("Remove Photo"),
              onTap: () {
                Navigator.pop(context);
                context
                    .read<DoctorProfileCubit>()
                    .updateDoctorProfile(widget.doctorId, {"image": ""});
              } // ✅ إصلاح الخطأ باستخدام دالة صحيحة
              ),
        ],
      ),
    );
  }

  // توليد لون بناءً على اسم المستخدم
  Color _generateColor(String name) {
    int hash = name.codeUnits.fold(0, (prev, char) => prev + char);
    return Colors.primaries[hash % Colors.primaries.length];
  }

  Widget buildName(Doctor doctor) {
    String initials = "";
    if (doctor.firstName.isNotEmpty) initials += doctor.firstName[0];
    if (doctor.lastName.isNotEmpty) initials += doctor.lastName[0];

    return CircleAvatar(
      radius: 45,
      backgroundColor: _generateColor(doctor.firstName + doctor.lastName),
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

void _showSpecializationDialog(BuildContext context, Doctor doctor) {
  List<String> specializations = [
    'Chest Radiology',
    'Abdominal Radiology',
    'Head and Neck Radiology',
    'Musculoskeletal Radiology',
    'Neuroradiology',
    'Thoracic Radiology',
    'Cardiovascular Radiology'
  ];

  Map<String, bool> isSelected = {
    for (var spec in specializations) spec: doctor.specialization.contains(spec)
  };

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Edit Specialization"),
            content: SizedBox(
              height: 300,
              width: double.maxFinite,
              child: ListView(
                children: isSelected.keys.map((spec) {
                  return CheckboxListTile(
                    title: Text(spec),
                    value: isSelected[spec],
                    activeColor: Colors.blue,
                    onChanged: (bool? value) {
                      setState(() {
                        isSelected[spec] = value ?? false;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: isSelected.values.contains(
                        true) // 🔹 تفعيل الزر فقط عند وجود تخصصات مختارة
                    ? () {
                        List<String> updatedSpecializations = isSelected.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();

                        Navigator.pop(context, updatedSpecializations);
                      }
                    : null, // ❌ تعطيل الزر إذا لم يكن هناك أي اختيار
                child: Text(
                  "Save",
                  style: TextStyle(
                    color: isSelected.values.contains(true)
                        ? Colors.blue
                        : Colors.grey, // 🔹 تغيير لون الزر عند تعطيله
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  ).then((updatedSpecializations) {
    if (updatedSpecializations != null) {
      context.read<DoctorProfileCubit>().updateDoctorProfile(
        doctor.id,
        {"specialization": updatedSpecializations},
      );
    }
  });
}
