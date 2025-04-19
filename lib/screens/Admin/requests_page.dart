import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/Admin/not_approved_centers_cubit.dart';
import 'package:graduation_project_frontend/models/Admin/approved_centers_model.dart';
import 'package:graduation_project_frontend/screens/Admin/center_info_page.dart';

class RadiologyCenter {
  final String name;
  final String id;
  final String email;
  final String phoneNumber;
  final String dateAdded;
  final String timeAdded;
  final bool isApproved;
  final String avatarAsset;

  RadiologyCenter({
    required this.name,
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.dateAdded,
    required this.timeAdded,
    required this.isApproved,
    required this.avatarAsset,
  });
}

class RequestsPage extends StatefulWidget {
  static final id = "RequestsPage";
  const RequestsPage({Key? key}) : super(key: key);

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotApprovedCentersCubit>().fetchAllCenters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTableHeader(),
            Expanded(
              child:
                  BlocBuilder<NotApprovedCentersCubit, NotApprovedCentersState>(
                      builder: (context, state) {
                if (state is NotApprovedCentersLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is NotApprovedCentersFailure) {
                  return Center(child: Text('Error: ${state.error}'));
                } else if (state is NotApprovedCentersSuccess) {
                  final centers = state.centers;

                  return ListView.builder(
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      return _buildRadiologyCenterRow(centers[index]);
                    },
                  );
                } else
                  return Text("NO");
              }),
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
              'List of Radiology Centers',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '??? available centers',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        // ElevatedButton.icon(
        //   onPressed: () {},
        //   icon: const Icon(Icons.add),
        //   label: const Text('Add new doctor'),
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: const Color(0xFF6B9E76),
        //     foregroundColor: Colors.white,
        //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        //   ),
        // ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // رمادي خفيف للخلفية
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
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
          Expanded(
            flex: 1,
            child: Text(
              'ID',
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
          Expanded(
            flex: 1,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildRadiologyCenterRow(Datum center) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.shade50,
            backgroundImage: AssetImage(center.image!),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    center.centerName!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Text(
                  //   doctor.specialty,
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.grey.shade600,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              center.id!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              center.email!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              center.contactNumber!,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  center.createdAt!.timeZoneName,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  center.createdAt!.day.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: center.isApproved!
                    ? const Color(0xFFEAF5EB)
                    : const Color(0xFFFFE8E8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                center.isApproved! ? 'Approved' : 'Declined',
                style: TextStyle(
                  fontSize: 12,
                  color: center.isApproved!
                      ? const Color(0xFF6B9E76)
                      : const Color(0xFFFF5D5D),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // context.read<CenterProfileCubit>().ViewCenterProfilePage();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ViewCenterProfilePage()),
              );
            },
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
