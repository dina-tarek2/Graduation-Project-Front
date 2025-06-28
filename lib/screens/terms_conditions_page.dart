import 'package:flutter/material.dart';

class TermsConditionsPage extends StatelessWidget {
  static const String id = '/terms_conditions';
  static const Color customBlue = Color(0xFF1B4965);

  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
                    Icons.description,
                    size: 48,
                    color: customBlue,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Terms & Conditions',
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

            // Agreement
            _buildSection(
              title: '1. Agreement to Terms',
              content:
                  'By accessing and using this Radiology Management System application, you accept and agree to be bound by the terms and provision of this agreement. These terms apply to all users of the application, including radiologists, medical centers, and administrative staff.',
            ),

            // Service Description
            _buildSection(
              title: '2. Service Description',
              content: 'Our platform provides:',
              children: [
                _buildBulletPoint(
                    'Connection between medical centers and certified radiologists'),
                _buildBulletPoint(
                    'Secure transmission and storage of medical images and reports'),
                _buildBulletPoint('Case management and tracking system'),
                _buildBulletPoint(
                    'Payment processing and wallet functionality'),
                _buildBulletPoint('Quality assurance and report validation'),
                _buildBulletPoint(
                    'Communication tools for medical consultations'),
              ],
            ),

            // User Responsibilities
            _buildSection(
              title: '3. User Responsibilities',
              content: 'All users must:',
              children: [
                _buildSubSection(
                  subtitle: '3.1 General Responsibilities',
                  points: [
                    'Provide accurate and up-to-date information',
                    'Maintain the confidentiality of login credentials',
                    'Use the service only for legitimate medical purposes',
                    'Comply with all applicable laws and regulations',
                    'Respect patient privacy and confidentiality',
                  ],
                ),
                _buildSubSection(
                  subtitle: '3.2 Radiologist Responsibilities',
                  points: [
                    'Maintain valid medical licenses and certifications',
                    'Provide accurate and timely radiology reports',
                    'Meet specified deadlines for urgent and normal cases',
                    'Maintain professional standards and ethics',
                    'Participate in quality assurance programs',
                  ],
                ),
                _buildSubSection(
                  subtitle: '3.3 Medical Center Responsibilities',
                  points: [
                    'Provide complete and accurate patient information',
                    'Ensure proper image quality and completeness',
                    'Make timely payments for services rendered',
                    'Maintain appropriate medical licenses',
                    'Follow patient consent protocols',
                  ],
                ),
              ],
            ),

            // Payment Terms
            _buildSection(
              title: '4. Payment Terms',
              content: 'Payment and billing terms:',
              children: [
                _buildBulletPoint(
                    'All payments are processed through secure payment gateways'),
                _buildBulletPoint(
                    'Medical centers must maintain sufficient wallet balance'),
                _buildBulletPoint(
                    'Payments are automatically deducted upon report completion'),
                _buildBulletPoint(
                    'Refunds may be issued for cancelled or incomplete cases'),
                _buildBulletPoint(
                    'Pricing may vary based on case complexity and urgency'),
                _buildBulletPoint(
                    'Transaction fees may apply for payment processing'),
              ],
            ),

            // Quality Standards
            _buildSection(
              title: '5. Quality Standards',
              content: 'We maintain high quality standards through:',
              children: [
                _buildBulletPoint(
                    'Verification of all radiologist credentials'),
                _buildBulletPoint('Regular quality audits and peer reviews'),
                _buildBulletPoint(
                    'Standardized reporting templates and protocols'),
                _buildBulletPoint(
                    'Continuous education and training requirements'),
                _buildBulletPoint('Patient safety and care quality monitoring'),
              ],
            ),

            // Prohibited Uses
            _buildSection(
              title: '6. Prohibited Uses',
              content: 'The following activities are strictly prohibited:',
              children: [
                _buildBulletPoint(
                    'Sharing login credentials with unauthorized persons'),
                _buildBulletPoint('Using the service for non-medical purposes'),
                _buildBulletPoint(
                    'Attempting to access unauthorized data or systems'),
                _buildBulletPoint(
                    'Uploading malicious software or harmful content'),
                _buildBulletPoint(
                    'Violating patient privacy or confidentiality'),
                _buildBulletPoint(
                    'Providing false or misleading medical information'),
                _buildBulletPoint(
                    'Engaging in fraudulent activities or billing practices'),
              ],
            ),

            // Intellectual Property
            _buildSection(
              title: '7. Intellectual Property',
              content:
                  'All content, features, and functionality of the application are owned by us and are protected by copyright, trademark, and other intellectual property laws. Users retain ownership of their medical data and reports while granting us necessary licenses to provide the service.',
            ),

            // Limitation of Liability
            _buildSection(
              title: '8. Limitation of Liability',
              content: 'Our liability is limited as follows:',
              children: [
                _buildBulletPoint(
                    'We provide a platform for medical consultation, not direct medical care'),
                _buildBulletPoint(
                    'Final medical decisions remain with treating physicians'),
                _buildBulletPoint(
                    'Users are responsible for maintaining professional standards'),
                _buildBulletPoint(
                    'Technical issues or system downtime may occasionally occur'),
                _buildBulletPoint(
                    'We maintain insurance and backup systems for data protection'),
              ],
            ),

            // Privacy and Data Protection
            _buildSection(
              title: '9. Privacy and Data Protection',
              content:
                  'We are committed to protecting user privacy and medical data through:',
              children: [
                _buildBulletPoint(
                    'Compliance with healthcare privacy regulations'),
                _buildBulletPoint('Secure encryption of all medical data'),
                _buildBulletPoint(
                    'Limited access to authorized personnel only'),
                _buildBulletPoint('Regular security audits and updates'),
                _buildBulletPoint('Transparent privacy policies and practices'),
              ],
            ),

            // Service Availability
            _buildSection(
              title: '10. Service Availability',
              content:
                  'While we strive for 24/7 availability, we cannot guarantee uninterrupted service due to:',
              children: [
                _buildBulletPoint('Scheduled maintenance and updates'),
                _buildBulletPoint('Technical difficulties or system failures'),
                _buildBulletPoint('Network connectivity issues'),
                _buildBulletPoint('Force majeure events'),
              ],
            ),

            // Termination
            _buildSection(
              title: '11. Account Termination',
              content: 'We reserve the right to terminate accounts for:',
              children: [
                _buildBulletPoint('Violation of these terms and conditions'),
                _buildBulletPoint('Fraudulent or unethical behavior'),
                _buildBulletPoint('Failure to maintain required credentials'),
                _buildBulletPoint('Non-payment of fees or services'),
                _buildBulletPoint('Inactivity for extended periods'),
              ],
            ),

            // Changes to Terms
            _buildSection(
              title: '12. Changes to Terms',
              content:
                  'We may update these terms periodically. Users will be notified of significant changes through the application or email. Continued use of the service after changes constitutes acceptance of the new terms.',
            ),

            // Governing Law
            _buildSection(
              title: '13. Governing Law',
              content:
                  'These terms are governed by the laws of Egypt. Any disputes will be resolved through appropriate legal channels in Cairo, Egypt.',
            ),

            // Contact Information
            _buildSection(
              title: '14. Contact Information',
              content: 'For questions about these terms, please contact us:',
              children: [
                _buildContactInfo('Email', 'legal@radiologyapp.com'),
                _buildContactInfo('Phone', '+20 xxx-xxx-xxxx'),
                _buildContactInfo('Address', 'Cairo, Egypt'),
                _buildContactInfo('Support', 'support@radiologyapp.com'),
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
    required List<String> points,
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
          ...points.map((point) => _buildBulletPoint(point)).toList(),
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
            width: 80,
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
