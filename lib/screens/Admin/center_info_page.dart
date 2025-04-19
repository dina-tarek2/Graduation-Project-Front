import 'package:flutter/material.dart';

class ViewCenterProfilePage extends StatefulWidget {
  static final id = "ViewCenterProfilePage";
  const ViewCenterProfilePage({super.key});

  @override
  State<ViewCenterProfilePage> createState() => _ViewCenterProfilePageState();
}

class _ViewCenterProfilePageState extends State<ViewCenterProfilePage> {
  // Center data model - can come from any source
  final Map<String, String> centerData = {
    'email': 'center@example.com',
    'password': '********', // We don't show the actual password
    'centerName': 'Hope Rehabilitation Center',
    'contactNo': '+201234567890',
    'city': 'Cairo',
    'zipCode': '11511',
    'street': 'El-Nasr Street',
    'state': 'Heliopolis',
  };

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate data loading
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column for the form (using only 40% of the screen width)
                Expanded(
                  flex: 4,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        // Add a max width constraint to limit the width
                        constraints: const BoxConstraints(maxWidth: 350),
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

                            // Single column layout for all fields
                            _buildFieldWithLabel(
                              label: 'Email',
                              value: centerData['email'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Password',
                              value: centerData['password'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Center Name',
                              value: centerData['centerName'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Contact No.',
                              value: centerData['contactNo'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'City',
                              value: centerData['city'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Zip Code',
                              value: centerData['zipCode'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'Street',
                              value: centerData['street'] ?? '',
                            ),
                            const SizedBox(height: 16),

                            _buildFieldWithLabel(
                              label: 'State',
                              value: centerData['state'] ?? '',
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Right column - larger space for additional content (60% of screen width)
                Expanded(
                  flex: 6,
                  child: Container(
                    // This is where you can add your custom content in the future
                    // For now, it's just an empty container with a subtle border
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(color: Colors.grey[200]!),
                      ),
                    ),
                  ),
                ),
              ],
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
