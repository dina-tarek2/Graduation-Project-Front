import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/Admin/manage_centers_cubit.dart';
import 'package:graduation_project_frontend/cubit/Admin/not_approved_centers_cubit.dart';
import 'package:graduation_project_frontend/models/Admin/approved_centers_model.dart';

class ViewCenterProfilePage extends StatefulWidget {
  static final id = "ViewCenterProfilePage";
  final String centerId;

  const ViewCenterProfilePage({super.key, required this.centerId});

  @override
  State<ViewCenterProfilePage> createState() => _ViewCenterProfilePageState();
}

class _ViewCenterProfilePageState extends State<ViewCenterProfilePage> {
  @override
  void initState() {
    super.initState();

    context.read<NotApprovedCentersCubit>().getCenterInfo(widget.centerId);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<NotApprovedCentersCubit, NotApprovedCentersState>(
        builder: (context, state) {
          if (state is centerInfoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is centerInfoFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is centerInfoSuccess) {
            Datum center = state.center;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First column - first set of info fields
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Row with back button and title
                            Row(
                              children: [
                                // Back button
                                IconButton(
                                  icon: const Icon(Icons.arrow_back, size: 24),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    context
                                        .read<NotApprovedCentersCubit>()
                                        .fetchAllCenters();
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 8),
                                // Basic information title
                                const Text(
                                  'Center Information',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // First column fields
                            _buildFieldWithLabel(
                              label: 'Email',
                              value: center.email ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Center Name',
                              value: center.centerName ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Contact No.',
                              value: center.contactNumber ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'City',
                              value: center.address!.city ?? '',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Second column - second set of info fields
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 300),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                                height:
                                    60), // Space for alignment with first column

                            _buildFieldWithLabel(
                              label: 'Zip Code',
                              value: center.address!.zipCode ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Street',
                              value: center.address!.street ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'State',
                              value: center.address!.state ?? '',
                            ),
                            const SizedBox(height: 16),

                            // Action buttons - added here
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Approve Button
                                SizedBox(
                                  width: 130,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add approval logic here
                                      context
                                          .read<NotApprovedCentersCubit>()
                                          .approveCenter(widget.centerId);
                                      context
                                          .read<NotApprovedCentersCubit>()
                                          .fetchAllCenters();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Approve',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),

                                // Disapprove Button
                                SizedBox(
                                  width:
                                      130, // ضبط العرض ليناسب زر "Edit Details"
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Add disapproval logic here
                                      context
                                          .read<ManageCentersCubit>()
                                          .removeCenter(
                                            widget.centerId,
                                          );
                                      context
                                          .read<NotApprovedCentersCubit>()
                                          .fetchAllCenters();
                                      Navigator.pop(context);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Disapprove',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Third column for license image
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            const Text(
                              'Radiology Center License Image',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildProfilePictureDisplay(
                                center.path!, screenSize),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text("no state");
          }
        },
      ),
    );
  }

  Widget _buildProfilePictureDisplay(String path, Size screenSize) {
    return Container(
      padding: const EdgeInsets.all(12), // زيادة الهامش الداخلي
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      // زيادة الحجم الأقصى للصورة
      constraints: BoxConstraints(
        maxWidth: screenSize.width * 0.65, // زيادة من 0.5 إلى 0.65
        maxHeight: screenSize.height * 0.8, // زيادة من 0.7 إلى 0.8
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 0.5,
          maxScale: 4,
          child: Image.network(
            path,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: 120, // زيادة حجم مؤشر التحميل
                height: 120,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image,
                        size: 80,
                        color: Colors.grey[400]), // زيادة حجم الأيقونة
                    const SizedBox(height: 16),
                    Text(
                      'No image available',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 16, // زيادة حجم الخط
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Combined widget for field label and value
  Widget _buildFieldWithLabel({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        _buildReadOnlyField(value: value),
      ],
    );
  }

  Widget _buildReadOnlyField({
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(4),
        color: Colors.grey[50], // Light background color to indicate read-only
      ),
      child: Text(
        value,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}
