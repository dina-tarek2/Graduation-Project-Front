
  
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);
static String id ='AboutUsPage';
  @override
  Widget build(BuildContext context) {
    // Get screen width to determine layout
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 900;
    final bool isTablet = screenWidth > 600 && screenWidth <= 900;

    return Scaffold(
      
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A539A), Color(0xFF063461)],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.medical_services_outlined,
                              size: 60,
                              color: Color(0xFF0A539A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Advanced Radiology Management System',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: isDesktop ? screenWidth * 0.6 : screenWidth * 0.9,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(
                            'Revolutionizing workflow between imaging centers, radiologists, and patients through an integrated three-tier platform.',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white70,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Main content
                isDesktop
                    ? _buildDesktopLayout(context)
                    : isTablet
                        ? _buildTabletLayout(context)
                        : _buildMobileLayout(context),

                const SizedBox(height: 40),

                // AI Advantage section
                _buildAiAdvantageSection(context),

                const SizedBox(height: 40),

                // Footer
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: [
                        Text(
                          'Designed with Flutter technology',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Prioritizing security, speed, and user satisfaction in the diagnostic journey.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSectionCard(context, 'Imaging Centers', _imagingCenterFeatures(), Icons.business)),
        const SizedBox(width: 16),
        Expanded(child: _buildSectionCard(context, 'Radiologists', _radiologistFeatures(), Icons.person)),
        const SizedBox(width: 16),
        Expanded(child: _buildSectionCard(context, 'Patients', _patientFeatures(), Icons.people)),
      ],
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildSectionCard(context, 'Imaging Centers', _imagingCenterFeatures(), Icons.business)),
            const SizedBox(width: 16),
            Expanded(child: _buildSectionCard(context, 'Radiologists', _radiologistFeatures(), Icons.person)),
          ],
        ),
        const SizedBox(height: 16),
        _buildSectionCard(context, 'Patients', _patientFeatures(), Icons.people),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        _buildSectionCard(context, 'Imaging Centers', _imagingCenterFeatures(), Icons.business),
        const SizedBox(height: 16),
        _buildSectionCard(context, 'Radiologists', _radiologistFeatures(), Icons.person),
        const SizedBox(height: 16),
        _buildSectionCard(context, 'Patients', _patientFeatures(), Icons.people),
      ],
    );
  }

  Widget _buildSectionCard(BuildContext context, String title, List<String> features, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF0A539A).withOpacity(0.1),
                  radius: 25,
                  child: Icon(
                    icon,
                    color: const Color(0xFF0A539A),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'For $title',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: const Color(0xFF0A539A),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...features.map((feature) => _buildFeatureItem(feature, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF0A539A),
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black87,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiAdvantageSection(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF0A539A), const Color(0xFF063461)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white24,
                  radius: 25,
                  child: Icon(
                    Icons.psychology,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Our AI Advantage',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ..._aiAdvantageFeatures().map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.white70,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white,
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<String> _imagingCenterFeatures() {
    return [
      'Upload DICOM files securely to our platform',
      'Track examination status through an intuitive dashboard',
      'Monitor radiologist workload and performance analytics',
      'Manage radiologist compensation and scheduling',
      'Communicate directly with radiologists via integrated chat',
      'Access statistical reports and operational metrics',
    ];
  }

  List<String> _radiologistFeatures() {
    return [
      'Instant notifications for new DICOM files requiring interpretation',
      'AI-powered specialty matching based on DICOM metadata',
      'Smart caseload distribution based on expertise and current workload',
      'Built-in advanced DICOM viewer with comprehensive visualization tools',
      'AI-generated preliminary reports for review and modification',
      'Seamless communication with imaging centers',
      'Option to decline cases when unavailable, with automatic reassignment',
    ];
  }

  List<String> _patientFeatures() {
    return [
      'Access radiology results quickly and securely',
      'View DICOM images through an intuitive viewer',
      'Share imaging studies and reports with referring physicians',
      'Track examination history and status updates',
    ];
  }

  List<String> _aiAdvantageFeatures() {
    return [
      'Automatically route studies to appropriate specialists based on study type',
      'Generate preliminary diagnostic reports for radiologist review',
      'Accelerate diagnosis while maintaining clinical accuracy',
      'Reduce radiologist workload through intelligent automation',
      'Ensure optimal resource allocation across the system',
    ];
  }
}