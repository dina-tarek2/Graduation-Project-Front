import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graduation_project_frontend/cubit/for_Center/center_profile_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/models/centers_model.dart';
import 'dart:io';
import 'package:graduation_project_frontend/constants/colors.dart';

class CenterProfile extends StatefulWidget {
  final String centerId;
  final String role;
  const CenterProfile({super.key, required this.centerId, required this.role});

  @override
  _CenterProfileState createState() => _CenterProfileState();
}

class _CenterProfileState extends State<CenterProfile> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    context.read<CenterProfileCubit>().fetchCenterProfile(widget.centerId);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _imageFile = File(pickedFile.path));
      context
          .read<CenterProfileCubit>()
          .updateProfileImage(widget.centerId, pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<CenterProfileCubit, CenterProfileState>(
        builder: (context, state) {
          if (state is CenterProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CenterProfileSuccess) {
            return _buildCenterProfile(state.center);
          } else if (state is CenterProfileError) {
            return Center(child: Text("Error: ${state.error}"));
          }
          return const Center(child: Text("No Data Available"));
        },
      ),
    );
  }

  Widget _buildCenterProfile(Center0 center) {
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
                        backgroundColor: blue,
                        backgroundImage: _imageFile != null
                            ? FileImage(_imageFile!) as ImageProvider
                            : (center.imageUrl.isNotEmpty
                                ? NetworkImage(center.imageUrl)
                                : null),
                        child: (_imageFile == null && center.imageUrl.isEmpty)
                            ? buildName(center)
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
                    "${center.centerName}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(center.email, style: TextStyle(color: grey)),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: center.id));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Copied to clipboard")),
                      );
                    },
                    child: Text(
                      "ID: ${center.id}",
                      style: const TextStyle(
                          color: blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
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
                    _editableInfoRow(Icons.person, "Center Name",
                        center.centerName, "centerName", center),
                    _editableInfoRow(Icons.phone, "Phone Number",
                        center.contactNumber, "contactNumber", center),
                    _infoRow(Icons.location_on, "Address",
                        "${center.address['street']}, ${center.address['city']},${center.address['state']}",
                        editable: true, isMultiline: true),
                    _editableInfoRow(
                      Icons.local_post_office,
                      "Zip code",
                      center.address['zipCode'],
                      "zipCode",
                      center,
                    ),
                    //   _infoRow(
                    //       Icons.access_time,
                    //       "Working Hours",
                    //       center.operatingHours.holidays.isEmpty
                    //           ? "No holidays"
                    //           : center.operatingHours.holidays.join(", "),
                    //       editable: false,
                    //       isMultiline: true),
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
    bool isMultiline = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color ?? blue, size: 22),
          const SizedBox(width: 8),
          Text(
            "$title: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
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
    Center0 center,
  ) {
    return _infoRow(icon, title, value,
        editable: true,
        isMultiline: true,
        onEdit: () => _showEditDialog(title, value, fieldKey));
  }

  void _showEditDialog(String title, String currentValue, String fieldKey) {
    TextEditingController controller =
        TextEditingController(text: currentValue);
    showDialog(
      context: context,
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
              context.read<CenterProfileCubit>().updateCenterProfile(
                  widget.centerId, {fieldKey: controller.text});
            },
            child: const Text("Save", style: TextStyle(color: blue)),
          ),
        ],
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: () {
              Navigator.pop(context);
              _pickImage(ImageSource.gallery);
            },
          ),
          ListTile(
              leading: const Icon(Icons.remove_circle_outline,
                  color: Color(0xFFFF0202)),
              title: const Text("Remove Photo"),
              onTap: () {
                Navigator.pop(context);
                context
                    .read<CenterProfileCubit>()
                    .updateCenterProfile(widget.centerId, {"image": ""});
              }),
        ],
      ),
    );
  }

  Color _generateColor(String name) {
    int hash = name.codeUnits.fold(0, (prev, char) => prev + char);
    return Colors.primaries[hash % Colors.primaries.length];
  }

  Widget buildName(Center0 center) {
    String initials = "";
    if (center.centerName.isNotEmpty) initials += center.centerName[0];

    return CircleAvatar(
      radius: 45,
      backgroundColor: _generateColor(center.centerName),
      child: Text(
        initials.toUpperCase(),
        style: const TextStyle(
            fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
