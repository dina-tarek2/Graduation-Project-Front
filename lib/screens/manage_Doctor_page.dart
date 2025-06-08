import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_cubit.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project_frontend/widgets/loading.dart';

@immutable
// ignore: must_be_immutable
class ManageDoctorsPage extends StatefulWidget {
  final String centerId;
  final List<dynamic> filteredDoctors = [];
  final String searchText = '';
  String selectedSpeciality = 'All';
  ManageDoctorsPage({super.key, required this.centerId});

  @override
  State<ManageDoctorsPage> createState() => _ManageDoctorsPageState();
}

class _ManageDoctorsPageState extends State<ManageDoctorsPage> {
  TextEditingController idRadiologist = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final DoctorCubit _doctorCubit = DoctorCubit(DioConsumer(dio: Dio()));

  @override
  void initState() {
    super.initState();
    _doctorCubit.fetchDoctors(widget.centerId);
  }

  @override
  void dispose() {
    idRadiologist.dispose();
    searchController.dispose();
    _doctorCubit.close();
    super.dispose();
  }

  Future<void> _refreshDoctorsList() async {
    if (!mounted) return;
    await _doctorCubit.fetchDoctors(widget.centerId);
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(color: Colors.blueAccent),
              SizedBox(height: 15),
              Text("Please wait...", style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddDoctorDialogByEmail(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 12,
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.only(top: 20, left: 20, right: 20),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        actionsPadding: EdgeInsets.only(bottom: 10, right: 10),
        title: Row(
          children: [
            Icon(FontAwesomeIcons.userDoctor, color: Colors.blueAccent),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                'You Can Added Doctor By email',
                style: customTextStyle(18, FontWeight.w500, Colors.grey[700]!),
              ),
            ),
          ],
        ),
        content: CustomFormTextField(
          controller: idRadiologist,
          hintText: 'Enter Doctor Email',
          validator: (value) {
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)) {
              return "Please write a valid email";
            }
            return null;
          },
          icon: FontAwesomeIcons.user,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            hintStyle: TextStyle(color: Colors.grey.shade600),
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              idRadiologist.clear();
            },
            icon: Icon(Icons.cancel, color: Colors.redAccent),
            label: Text(
              "Cancel",
              style: customTextStyle(18, FontWeight.w300, Colors.redAccent),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              elevation: 5,
            ),
             onPressed: () async {
              final email = idRadiologist.text.trim();
              if (email.isEmpty ||
                  !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
                showAdvancedNotification(
                  dialogContext,
                  message: "Please enter a valid email address.",
                  type: NotificationType.warning,
                  style: AnimationStyle.card,
                );
                return;
              }
              
              // Close the dialog first
              Navigator.of(dialogContext).pop();
              
              // Store the email before clearing the controller
              final doctorEmail = email;
              idRadiologist.clear();
           
              try {
                // Use the cubit directly through the instance variable
                await _doctorCubit.AddDoctorByEmail(doctorEmail, widget.centerId);
                
                // Show success notification
                showAdvancedNotification(
                  context,
                  message: "Doctor invitation sent successfully!",
                  type: NotificationType.success,
                  style: AnimationStyle.card,
                );
                
                // Manually refresh the list
                await _refreshDoctorsList();
              } catch (e) {
                
                // Show error notification
                showAdvancedNotification(
                  context,
                  message: "Failed to add doctor: ${e.toString()}",
                  type: NotificationType.error,
                  style: AnimationStyle.card,
                );
              }
            },
            icon: Icon(FontAwesomeIcons.paperPlane),
            label: Text(
              'Send',
              style: customTextStyle(18, FontWeight.w400, blue),
            ),
          )
        ],
      ),
    );
  }

  void _showAddDoctorDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 12,
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.only(top: 20, left: 20, right: 20),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            actionsPadding: EdgeInsets.only(bottom: 10, right: 10),
            title: Row(
              children: [
                Icon(Icons.person_add_alt_1_rounded, color: Colors.blueAccent),
                SizedBox(width: 12),
                Flexible(
                  child: Text(
                    'Add Doctor',
                    style: customTextStyle(30, FontWeight.w600, Colors.black),
                  ),
                ),
              ],
            ),
            content: CustomFormTextField(
              controller: idRadiologist,
              hintText: 'Enter Doctor Id',
              width: 45,
              icon: Icons.badge_outlined,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                // validator:,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                hintStyle: TextStyle(color: Colors.grey.shade600),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  idRadiologist.clear();
                },
                icon: Icon(Icons.cancel, color: Colors.redAccent),
                label: Text(
                  "Cancel",
                  style: customTextStyle(15, FontWeight.w300, Colors.redAccent),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  elevation: 4,
                ),
                onPressed: () async {
                  final doctorId = idRadiologist.text.trim();

                  final existingDoctors = _doctorCubit.doctors
                      .where((doctor) => doctor.id == doctorId)
                      .toList();

                  if (existingDoctors.isNotEmpty) {
                    showAdvancedNotification(
                      context,
                      message: "Radiologist is already assigned to this center",
                      type: NotificationType.warning,
                      style: AnimationStyle.card,
                    );
                    Navigator.of(dialogContext).pop();
                    idRadiologist.clear();
                    return;
                  }
                  Navigator.of(dialogContext).pop();
                  await _doctorCubit.AddDoctor(doctorId, widget.centerId);
                  idRadiologist.clear();
                },
                icon: Icon(Icons.check_circle_outline),
                label: Text('Ok'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;
    final isMobile = screenWidth < 768;
    
    return BlocProvider.value(
        value: _doctorCubit,
        child: Builder(builder: (context) {
          return BlocListener<DoctorCubit, DoctorListState>(
            listener: (context, state) {
              if (state is DoctorAddedSuccess) {
                showAdvancedNotification(
                  context,
                  message: state.message,
                  type: NotificationType.success,
                  style: AnimationStyle.card,
                );
                // Only refresh the doctors list, not the entire page
                _refreshDoctorsList();
              } else if (state is DoctorDeletedSuccess) {
                // Show success notification if needed
                showAdvancedNotification(
                  context,
                  message: state.message,
                  type: NotificationType.success,
                  style: AnimationStyle.card,
                );
              } else if (state is DoctorListError) {
                // Show success notification if needed
                showAdvancedNotification(
                  context,
                  message: state.error,
                  type: NotificationType.error,
                  style: AnimationStyle.card,
                );
                // Only refresh the doctors list, not the entire page
                // _refreshDoctorsList();
              }
            },
            child: RefreshIndicator(
              onRefresh: _refreshDoctorsList,
              child: Scaffold(
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(isMobile ? 12.0 : 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your Medical Team",
                                  style: TextStyle(
                                    fontSize: isMobile ? 22 : 26,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 4),
                                BlocBuilder<DoctorCubit, DoctorListState>(
                                  builder: (context, state) {
                                    if (state is DoctorListSuccess) {
                                      return Text(
                                          "${state.doctors.length} doctors available",
                                          style: customTextStyle(
                                              isMobile ? 16 : 20,
                                              FontWeight.w500,
                                              Colors.grey.shade600));
                                    }
                                    return Text("Loading doctors...",
                                        style: customTextStyle(
                                            isMobile ? 16 : 20,
                                            FontWeight.w500,
                                            Colors.grey.shade600));
                                  },
                                ),
                                SizedBox(height: 16),
                                _buildSearchAndFilter(isMobile, isTablet),
                              ],
                            ),
                          ),
                          SizedBox(width: 12),
                        ],
                      ),
                    ),
                    Expanded(
                      child: BlocBuilder<DoctorCubit, DoctorListState>(
                        builder: (context, state) {
                          if (state is DoctorListLoading) {
                            return Center(
                              child: LoadingOverlay(),
                            );
                          } else if (state is DoctorListSuccess) {
                            final doctors = state.doctors;
                            final filteredDoctors = _filterDoctors(doctors);
                            return filteredDoctors.isEmpty
                                ? _buildEmptyState(context, isMobile)
                                : _buildDoctorsList(context, filteredDoctors, isMobile, isTablet);
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    _showAddDoctorDialogByEmail(context);
                  },
                  tooltip: "Add New Doctor",
                  backgroundColor: blue,
                  elevation: 8,
                  child: Icon(
                    FontAwesomeIcons.plus,
                    size: isMobile ? 24 : 30,
                    color: sky,
                  ),
                ),
              ),
            ),
          );
        }));
  }

  List<dynamic> _filterDoctors(List<dynamic> doctors) {
    String searchText = searchController.text.toLowerCase();
    String selectedSpeciality = widget.selectedSpeciality;

    return doctors.where((doctor) {
      bool matchesSearch =
          doctor.firstName.toLowerCase().contains(searchText) ||
              doctor.lastName.toLowerCase().contains(searchText);
      bool matchesSpeciality = selectedSpeciality == 'All' ||
          doctor.specialization.contains(selectedSpeciality);

      return matchesSearch && matchesSpeciality;
    }).toList();
  }

  Widget _buildSearchAndFilter(bool isMobile, bool isTablet) {
    return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.symmetric(vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isMobile 
              ? Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search by Name',
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 12),
                      decoration: BoxDecoration(
                        color: blue,
                        border: Border.all(color: blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButton<String>(
                        value: widget.selectedSpeciality,
                        isExpanded: true,
                        underline: SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                        dropdownColor: blue,
                        style: customTextStyle(isMobile ? 16 : 20, FontWeight.w500, Colors.white),
                        onChanged: (value) {
                          setState(() {
                            widget.selectedSpeciality = value!;
                          });
                        },
                        items: [
                          'All',
                          'Chest Radiology',
                          'Abdominal Radiology',
                          'Head and Neck Radiology',
                          'Neuroradiology',
                          'Musculoskeletal Radiology',
                          'Thoracic Radiology',
                          'Cardiovascular Radiology'
                        ].map((speciality) {
                          return DropdownMenuItem<String>(
                            value: speciality,
                            child: Text(speciality),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: 'Search by Name',
                          prefixIcon: Icon(Icons.search),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.only(left: 12),
                        decoration: BoxDecoration(
                          color: blue,
                          border: Border.all(color: blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          value: widget.selectedSpeciality,
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.white,
                          ),
                          dropdownColor: blue,
                          style: customTextStyle(isTablet ? 18 : 20, FontWeight.w500, Colors.white),
                          onChanged: (value) {
                            setState(() {
                              widget.selectedSpeciality = value!;
                            });
                          },
                          items: [
                            'All',
                            'Chest Radiology',
                            'Abdominal Radiology',
                            'Head and Neck Radiology',
                            'Neuroradiology',
                            'Musculoskeletal Radiology',
                            'Thoracic Radiology',
                            'Cardiovascular Radiology'
                          ].map((speciality) {
                            return DropdownMenuItem<String>(
                              value: speciality,
                              child: Text(speciality),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }

  Widget _buildDoctorsList(BuildContext context, List<dynamic> doctors, bool isMobile, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 8.0 : 16.0),
      child: DoctorTable(
        doctors: doctors,
        isMobile: isMobile,
        isTablet: isTablet,
        onDelete: (doctor) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Flexible(
                    child: Text("Confirm Deletion",
                        style: customTextStyle(
                            isMobile ? 22 : 26, FontWeight.w600, Colors.grey.shade600)),
                  ),
                ],
              ),
              content: Text("Do you want to delete Dr. ${doctor.firstName}?",
                  style: customTextStyle(isMobile ? 16 : 20, FontWeight.w400, Colors.black)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel",
                      style: customTextStyle(
                          14, FontWeight.w400, Colors.grey.shade700)),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  icon: Icon(Icons.delete_outline, size: 20),
                  label: Text("Delete"),
                  onPressed: () async {
                    final doctorsCubit = context.read<DoctorCubit>();
                    Navigator.pop(context);
                    await doctorsCubit.deleteDoctors(
                        doctor.id, widget.centerId);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off_outlined,
            size: isMobile ? 60 : 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "No doctors found",
            style: customTextStyle(isMobile ? 16 : 18, FontWeight.w500, Colors.grey.shade600),
          ),
          SizedBox(height: 8),
          Text(
            "Add doctors to your medical center",
            style: customTextStyle(isMobile ? 12 : 14, FontWeight.w500, Colors.grey.shade600),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showAddDoctorDialog(context);
            },
            icon: Icon(Icons.add),
            label: Text("Add Doctor"),
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                shadowColor: Colors.blueGrey,
                textStyle: customTextStyle(16, FontWeight.w500, Colors.white)),
          ),
        ],
      ),
    );
  }
}

class DoctorTable extends StatelessWidget {
  final List<dynamic> doctors;
  final Function(dynamic) onDelete;
  final bool isMobile;
  final bool isTablet;
  
  DoctorTable({
    Key? key,
    required this.doctors,
    required this.onDelete,
    required this.isMobile,
    required this.isTablet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return _buildMobileLayout();
    } else {
      return _buildDesktopLayout();
    }
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      itemCount: doctors.length,
      padding: EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(doctor.imageUrl),
                      radius: 25,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Dr. ${doctor.firstName} ${doctor.lastName}",
                            style: customTextStyle(16, FontWeight.w600, Colors.black),
                          ),
                          SizedBox(height: 2),
                          Text(
                            doctor.email,
                            style: customTextStyle(14, FontWeight.w400, Colors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          size: 24, color: Colors.red.shade300),
                      onPressed: () => onDelete(doctor),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.stethoscope, size: 14, color: blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        doctor.specialization.join(", "),
                        style: customTextStyle(14, FontWeight.w500, blue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(FontAwesomeIcons.fileLines, size: 14, color: blue),
                    SizedBox(width: 8),
                    Text(
                      "Reports: ${doctor.totalReports}",
                      style: customTextStyle(14, FontWeight.w500, blue),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: 800),
          child: DataTable(
            columnSpacing: isTablet ? 16 : 24,
            headingRowColor: WidgetStateProperty.all<Color>(darkBlue),
            dataRowMinHeight: 60,
            dataRowMaxHeight: 70,
            headingTextStyle: customTextStyle(isTablet ? 16 : 18, FontWeight.bold, Colors.white),
            columns: [
              DataColumn(
                  label: Row(
                children: [
                  Icon(FontAwesomeIcons.userDoctor, size: isTablet ? 16 : 19, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Doctor',
                    style: customTextStyle(isTablet ? 18 : 20, FontWeight.w600, Colors.white),
                  ),
                ],
              )),
              DataColumn(
                  label: Row(
                children: [
                  Icon(FontAwesomeIcons.stethoscope, size: isTablet ? 15 : 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Speciality',
                    style: customTextStyle(isTablet ? 18 : 20, FontWeight.w600, Colors.white),
                  ),
                ],
              )),
              DataColumn(
                  label: Row(
                children: [
                  Icon(FontAwesomeIcons.fileLines, size: isTablet ? 15 : 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Reports',
                    style: customTextStyle(isTablet ? 18 : 20, FontWeight.w600, Colors.white),
                  ),
                ],
              )),
              DataColumn(
                  label: Row(
                children: [
                  Icon(FontAwesomeIcons.sliders, size: isTablet ? 15 : 18, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Action',
                    style: customTextStyle(isTablet ? 18 : 20, FontWeight.w600, Colors.white),
                  ),
                ],
              )),
            ],
            rows: doctors.map((doctor) {
              return DataRow(
                color: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.hovered)) return Colors.white;
                  return Colors.white;
                }),
                cells: [
                  DataCell(
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(doctor.imageUrl),
                            radius: isTablet ? 16 : 18,
                          ),
                          SizedBox(width: 8),
                          Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                            Text(
                              "Dr. ${doctor.firstName} ${doctor.lastName}",
                              style: customTextStyle(
                                  isTablet ? 16 : 18, FontWeight.w500, Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          
                        Text(
                          "${doctor.email}",
                          style: customTextStyle(isTablet ? 14 : 18, FontWeight.w300, Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  ],
                      ),
                      ),
                  DataCell(
                    Flexible(
                      child: Text(
                        doctor.specialization.join(", "),
                        style: customTextStyle(isTablet ? 16 : 18, FontWeight.w500, blue),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                    DataCell(
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                     
                      child: Text(
                        "${doctor.totalReports}",
                        style: customTextStyle(isTablet ? 18 : 21, FontWeight.w600, blue),
                      ),
                    ),
                  ),
                  DataCell(
                    IconButton(
                      icon: Icon(Icons.delete_outline_rounded,
                          size: isTablet ? 22 : 25, color: Colors.red.shade300),
                      tooltip: "Delete",
                      onPressed: () {
                        onDelete(doctor);
                      },
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}