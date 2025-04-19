import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/Admin/manage_centers_cubit.dart';

class AddCenterPage extends StatefulWidget {
  static final id = "AddCenterPage";
  const AddCenterPage({super.key});

  @override
  State<AddCenterPage> createState() => _AddCenterPageState();
}

class _AddCenterPageState extends State<AddCenterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ManageCentersCubit, ManageCentersState>(
        listener: (context, state) {
          if (state is AddCenterSuccess) {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Done'),
                        content: Text('Center Added Successfully'),
                        actions: [
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop(); // يغلق الـ dialog
                              Navigator.of(context).pop(); // يرجع لصفحة قبلها مثلاً
                            },
                          ),
                        ],
                      );
                    },
                  );
                // });

                // return const SizedBox(); // لازم ترجع Widget حتى لو فارغ
              }
        },
        builder: (context, state) {
          return BlocBuilder<ManageCentersCubit, ManageCentersState>(
            builder: (context, state) {
              if (state is AddCenterFailure) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row with back button and title
                        Row(
                          children: [
                            // Back button
                            IconButton(
                              icon: const Icon(Icons.arrow_back, size: 28),
                              onPressed: () {
                                Navigator.pop(
                                    context); // Go back to previous page
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 10),
                            // Basic information title
                            const Text(
                              'Basic information',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .emailController,
                                    hintText: 'email',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .passwordController,
                                    hintText: 'password',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Center name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .centerNameController,
                                    hintText: 'center name',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact No.',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .contactNoController,
                                    hintText: 'contact number',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'City',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .cityController,
                                    hintText: 'city',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Zip Code',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .zipCodeController,
                                    hintText: 'zip code(must be 5 numbers)',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Street',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .streetController,
                                    hintText: 'street',
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'State',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildTextField(
                                    controller: context
                                        .read<ManageCentersCubit>()
                                        .stateController,
                                    hintText: 'state',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const SizedBox(height: 40),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle add button
                              context.read<ManageCentersCubit>().AddCenter();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 16),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text('Add'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: blue),
        ),
      ),
    );
  }
}
