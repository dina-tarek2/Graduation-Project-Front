import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Admin/doctors_cubit.dart';
import 'package:graduation_project_frontend/models/Admin/docotors_model.dart';

class ManageDoctorsaPage extends StatefulWidget {
  static final id = "ManageDoctorsaPage";
  const ManageDoctorsaPage({super.key});

  @override
  State<ManageDoctorsaPage> createState() => _ManageDoctorsaPageState();
}

class _ManageDoctorsaPageState extends State<ManageDoctorsaPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorsCubit>().fetchDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sky,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTableHeader(),
            Expanded(
              child: BlocConsumer<DoctorsCubit, DoctorsState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  if (state is DoctorsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is DoctorsFailure) {
                    return Center(child: Text('Error: ${state.error}'));
                  } else if (state is DoctorsSuccess) {
                    final doctors = state.doctors;
                    return ListView.builder(
                      itemCount: doctors.length,
                      itemBuilder: (context, index) {
                        return _buildDoctorRow(doctors[index]);
                      },
                    );
                  } else {
                    return const Text("no state");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'List of doctors',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Text(
            //   '؟؟؟ available doctors',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add new doctor'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B9E76),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            flex: 2,
            child: Text(
              'Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Text(
          //     'ID',
          //     style: TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.grey.shade600,
          //     ),
          //   ),
          // ),
          Expanded(
            flex: 2,
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Phone number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date added',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Text(
          //     'STATUS',
          //     style: TextStyle(
          //       fontSize: 14,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.grey.shade600,
          //     ),
          //   ),
          // ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDoctorRow(Datum doctor) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          
          SizedBox(
            width: 40,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              backgroundImage:
                  doctor.image != null ? NetworkImage(doctor.image!) : null,
              child: doctor.image == null ? Icon(Icons.person) : null,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${doctor.firstName!} ${doctor.lastName!}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialization.toList().first, //???????
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Text(
          //     doctor.id,
          //     style: const TextStyle(fontSize: 14),
          //   ),
          // ),
          Expanded(
            flex: 2,
            child: Text(
              doctor.email!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              doctor.contactNumber!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${doctor.createdAt!.hour}:${doctor.createdAt!.minute.toString().padLeft(2, '0')}:${doctor.createdAt!.second.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${doctor.createdAt!.day}/${doctor.createdAt!.month}/${doctor.createdAt!.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          //actions ?????????

          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
