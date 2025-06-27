import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  static const String id = '/privacy_policy';
  static const Color customBlue = Color(0xFF1B4965);

  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        backgroundColor: customBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: customBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: customBlue.withOpacity(0.2),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    size: 48,
                    color: customBlue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: customBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Introduction
            _buildSection(
              title: '1. Introduction',
              content:
                  'Welcome to our Radiology Management System. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services. We are committed to protecting your privacy and ensuring the security of your personal and medical information.',
            ),

            // Information We Collect
            _buildSection(
              title: '2. Information We Collect',
              content: 'We collect the following types of information:',
              children: [
                _buildSubSection(
                  subtitle: '2.1 Personal Information',
                  content:
                      '• Name, email address, phone number\n• Professional credentials and licenses\n• Medical center information\n• Profile pictures and professional details',
                ),
                _buildSubSection(
                  subtitle: '2.2 Medical Information',
                  content:
                      '• Radiology reports and findings\n• Medical images and scans\n• Patient diagnostic information\n• Treatment recommendations',
                ),
                _buildSubSection(
                  subtitle: '2.3 Technical Information',
                  content:
                      '• Device information and identifiers\n• Usage data and app interactions\n• Log files and error reports\n• Location data (when permitted)',
                ),
              ],
            ),

            // How We Use Information
            _buildSection(
              title: '3. How We Use Your Information',
              content: 'We use collected information for:',
              children: [
                _buildBulletPoint(
                    'Providing radiology services and report generation'),
                _buildBulletPoint(
                    'Facilitating communication between medical centers and radiologists'),
                _buildBulletPoint(
                    'Processing payments and maintaining wallet functionality'),
                _buildBulletPoint(
                    'Ensuring quality control and medical accuracy'),
                _buildBulletPoint(
                    'Sending notifications about cases and updates'),
                _buildBulletPoint('Improving our services and user experience'),
                _buildBulletPoint(
                    'Complying with legal and regulatory requirements'),
              ],
            ),

            // Data Security
            _buildSection(
              title: '4. Data Security',
              content:
                  'We implement industry-standard security measures to protect your information:',
              children: [
                _buildBulletPoint(
                    'End-to-end encryption for medical data transmission'),
                _buildBulletPoint(
                    'Secure servers with regular security audits'),
                _buildBulletPoint(
                    'Access controls and authentication protocols'),
                _buildBulletPoint(
                    'Regular data backups and disaster recovery plans'),
                _buildBulletPoint(
                    'Compliance with healthcare data protection standards'),
              ],
            ),

            // Data Sharing
            _buildSection(
              title: '5. Information Sharing',
              content:
                  'We may share your information only in the following circumstances:',
              children: [
                _buildBulletPoint(
                    'With authorized radiologists for case consultation'),
                _buildBulletPoint(
                    'With medical centers for patient care coordination'),
                _buildBulletPoint(
                    'With payment processors for transaction processing'),
                _buildBulletPoint('When required by law or legal proceedings'),
                _buildBulletPoint(
                    'With your explicit consent for specific purposes'),
              ],
            ),

            // User Rights
            _buildSection(
              title: '6. Your Rights',
              content: 'You have the right to:',
              children: [
                _buildBulletPoint(
                    'Access your personal and medical information'),
                _buildBulletPoint('Request correction of inaccurate data'),
                _buildBulletPoint('Delete your account and associated data'),
                _buildBulletPoint('Export your data in a portable format'),
                _buildBulletPoint('Opt-out of non-essential communications'),
                _buildBulletPoint('Withdraw consent for data processing'),
              ],
            ),

            // Data Retention
            _buildSection(
              title: '7. Data Retention',
              content:
                  'We retain your information for as long as necessary to:',
              children: [
                _buildBulletPoint('Provide ongoing medical services'),
                _buildBulletPoint(
                    'Comply with legal and regulatory requirements'),
                _buildBulletPoint(
                    'Maintain medical records as required by law'),
                _buildBulletPoint('Resolve disputes and enforce agreements'),
              ],
            ),

            // Contact Information
            _buildSection(
              title: '8. Contact Us',
              content:
                  'If you have questions about this Privacy Policy or our data practices, please contact us:',
              children: [
                _buildContactInfo('Email', 'privacy@radiologyapp.com'),
                _buildContactInfo('Phone', '+20 xxx-xxx-xxxx'),
                _buildContactInfo('Address', 'Cairo, Egypt'),
              ],
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String content,
    List<Widget>? children,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: customBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
          if (children != null) ...[
            const SizedBox(height: 8),
            ...children,
          ],
        ],
      ),
    );
  }

  Widget _buildSubSection({
    required String subtitle,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: customBlue,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 14,
              color: customBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: customBlue,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
