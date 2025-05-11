import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/Admin/manage_centers_cubit.dart';
import 'package:graduation_project_frontend/screens/Admin/add_center_page.dart';

class ManageCentersPage extends StatefulWidget {
  static final id = "ManageCentersPage";
  @override
  State<ManageCentersPage> createState() => _ManageCentersPageState();
}

class _ManageCentersPageState extends State<ManageCentersPage> {
  @override
  void initState() {
    super.initState();
    context.read<ManageCentersCubit>().fetchApprovedCenters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top Bar
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                // Search Bar
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF64748B)),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Radiology Centers',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 20),

                // Send Request Button
                ElevatedButton.icon(
                  icon: Icon(Icons.add, size: 16),
                  label: Text('Add Center'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0EA5E9),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddCenterPage()),
                    );
                  },
                ),
              ],
            ),
          ),

          // Content Area
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'All Radiology Centers',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Centers Grid
                    Expanded(
                      child:
                          BlocConsumer<ManageCentersCubit, ManageCentersState>(
                        listener: (context, state) {
                          if (state is DeletedSuccessfully) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Center deleted successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else if (state is DeletedFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to delete center.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is ManageCentersLoading) {
                            return Center(child: CircularProgressIndicator());
                          } else if (state is ManageCentersFailure) {
                            return Center(child: Text('Error: ${state.error}'));
                          } else if (state is ManageCentersSuccess) {
                            final centers = state.centers;
                            return GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 2.5,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              children: List.generate(centers.length, (index) {
                                final center = centers[index];
                                return _buildRadiologyCenterCard(
                                    center.image ?? " ",
                                    center.centerName ?? 'No Name',
                                    center.email ?? 'No Description',
                                    center.recordsCountPerDay!.count ?? 0,
                                    center.id!);
                              }),
                            );
                          } else {
                            return Center(child: Text('No data loaded'));
                          }
                        },
                      ),
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadiologyCenterCard(String image, String name, String bio,
      int recordsCountPerDay, String centerId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Keep existing header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFE2E8F0),
                    radius: 20,
                    backgroundImage:
                        image.trim().isNotEmpty ? NetworkImage(image) : null,
                    child: image.trim().isEmpty
                        ? Icon(Icons.person, color: Color(0xFF94A3B8))
                        : null,
                  ),
                  SizedBox(width: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                '$recordsCountPerDay Record',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            bio,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),

          // Add the new buttons row similar to the example image
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Remove button
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext dialogContext) {
                      return AlertDialog(
                        title: Text('Confirm Deletion'),
                        content: Text(
                            'Are you sure you want to delete this center?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext)
                                  .pop(); // Close the dialog
                              context.read<ManageCentersCubit>().removeCenter(
                                  centerId); // Call the delete method
                                  context.read<ManageCentersCubit>().fetchApprovedCenters()
                                  ; 
                            },
                            child: Text('Yes, Delete'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Remove',
                  style: TextStyle(
                    color: Color(0xFF0EA5E9),
                    fontSize: 14,
                  ),
                ),
              ),

              // Details button
              ElevatedButton(
                onPressed: () {
                  // Add your details functionality here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF0EA5E9),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.chevron_right, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
