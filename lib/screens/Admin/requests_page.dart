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

                  return centers.length == 0 ?
                   const Text("No Recently Requests.")
                   :  ListView.builder(
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
            // Text(
            //   '??? available centers',
            //   style: TextStyle(
            //     fontSize: 14,
            //     color: Colors.grey.shade600,
            //   ),
            // ),
          ],
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
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar space
          SizedBox(width: 40),
          Expanded(
            flex: 3,
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
            flex: 4,
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
            flex: 3,
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
            flex: 3,
            child: Text(
              'Date added',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          SizedBox(width: 60),
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
          SizedBox(
            width: 40,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.blue.shade50,
              backgroundImage:
                  center.image != null ? NetworkImage(center.image!) : null,
              child: center.image == null ? Icon(Icons.person) : null,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              center.centerName!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              center.email!,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              center.contactNumber!,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${center.createdAt!.hour}:${center.createdAt!.minute.toString().padLeft(2, '0')}:${center.createdAt!.second.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '${center.createdAt!.day}/${center.createdAt!.month}/${center.createdAt!.year}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 60,
            child: IconButton(
              onPressed: () {
                // print("herwee id ${center.id}");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewCenterProfilePage(
                            centerId: center.id!,
                          )),
                );
              },
              icon: const Icon(Icons.chevron_right, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
