import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/contact_cubit.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';

class ContactScreen extends StatelessWidget {
  static String id = 'ContactScreen';
  static const String routeName = '/contact';

  const ContactScreen({
    super.key,
    required this.role,
  });

  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Responsive layout - stack on mobile, row on desktop
          if (constraints.maxWidth < 768) {
            return _buildMobileLayout(context);
          }
          return _buildDesktopLayout(context);
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _buildImageSection(context),
        ),
        Expanded(
          flex: 3,
          child: _buildFormSection(context),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: _buildImageSection(context),
        ),
        Expanded(
          child: _buildFormSection(context),
        ),
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B4965), // Dark blue matching sidebar
            const Color(0xFF296992), // Medium blue
            const Color(0xFF60a5fa), // Light blue
          ],
          stops: const [0.0, 0.8, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Animated background circles
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Modern icon container
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      FontAwesomeIcons.commentDots,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Modern title with glassmorphism effect
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Get in Touch',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                letterSpacing: 1.2,
                              ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Text(
                  // 'We\'d love to hear from you',
                  //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  //         color: Colors.white.withOpacity(0.9),
                  //         fontSize: 16,
                  //         fontWeight: FontWeight.w300,
                  //       ),
                  // ),
                  const SizedBox(height: 32),
                  // Feature highlights
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFeatureItem(FontAwesomeIcons.bolt, '24/7 Support'),
                      const SizedBox(width: 32),
                      _buildFeatureItem(FontAwesomeIcons.shield, 'Secure'),
                      const SizedBox(width: 32),
                      _buildFeatureItem(
                          FontAwesomeIcons.rocket, 'Fast Response'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildFormSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC), // Very light blue-gray background
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4965).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(-5, 0),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.width > 768 ? 48.0 : 24.0,
          ),
          child: BlocConsumer<ContactCubit, ContactState>(
            listener: _handleStateChanges,
            builder: (context, state) => _buildForm(context, state),
          ),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, ContactState state) {
    switch (state) {
      case ContactSuccess():
        _showSuccessNotification(context);
        _clearForm(context);
        break;
      case ContactFailure():
        _showErrorNotification(context, state.error);
        break;
      default:
        break;
    }
  }

  void _showSuccessNotification(BuildContext context) {
    showAdvancedNotification(
      context,
      message: "Message sent successfully!",
      type: NotificationType.success,
      style: AnimationStyle.card,
    );
  }

  void _showErrorNotification(BuildContext context, String error) {
    showAdvancedNotification(
      context,
      message: "Failed to send message: $error",
      type: NotificationType.error,
      style: AnimationStyle.card,
    );
  }

  void _clearForm(BuildContext context) {
    final cubit = context.read<ContactCubit>();
    cubit.emailController.clear();
    cubit.nameController.clear();
    cubit.phoneController.clear();
    cubit.messageController.clear();
  }

  Widget _buildForm(BuildContext context, ContactState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: 32),
        Expanded(
          child: SingleChildScrollView(
            child: _buildFormFields(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = MediaQuery.of(context).size.width > 768;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1B4965)
                .withOpacity(0.1), // Light version of sidebar blue
            const Color(0xFF296992).withOpacity(0.05), // Very light blue
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF296992).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1B4965), // Dark blue matching sidebar
                      const Color(0xFF296992), // Medium blue
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  FontAwesomeIcons.envelope,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Us',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isDesktop ? 32 : 28,
                        color: const Color(0xFF1B4965), // Dark blue text
                      ),
                    ),
                    Text(
                      'Let\'s start a conversation',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF64748b), // Slate gray
                        fontSize: isDesktop ? 16 : 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1B4965).withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.at,
                  color: const Color(0xFF296992),
                  size: 16,
                ),
                const SizedBox(width: 12),
                Text(
                  'You can reach us anytime via',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748b),
                    fontSize: isDesktop ? 14 : 12,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _launchEmail('radintelio@gmail.com'),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1B4965),
                          const Color(0xFF296992),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'radintelio@gmail.com',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: isDesktop ? 12 : 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields(BuildContext context, ContactState state) {
    final cubit = context.read<ContactCubit>();

    return Column(
      children: [
        _buildTextField(
          controller: cubit.nameController,
          hintText: 'Enter your name',
          labelText: 'Name',
          icon: FontAwesomeIcons.user,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: cubit.emailController,
          hintText: 'Enter your email',
          labelText: 'Email',
          icon: FontAwesomeIcons.envelope,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: cubit.phoneController,
          hintText: 'Enter your phone number',
          labelText: 'Phone',
          icon: FontAwesomeIcons.phone,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: cubit.messageController,
          hintText: 'Enter your message',
          labelText: 'How can we help you?',
          icon: FontAwesomeIcons.commentDots,
          maxLines: 5,
        ),
        const SizedBox(height: 32),
        _buildSubmitButton(context, state),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return CustomFormTextField(
      controller: controller,
      hintText: hintText,
      labelText: labelText,
      icon: icon,
      maxLines: maxLines,
      // Note: keyboardType parameter removed as it's not supported by CustomFormTextField
      // You may need to add this parameter to your CustomFormTextField widget
    );
  }

  Widget _buildSubmitButton(BuildContext context, ContactState state) {
    final isLoading = state is ContactLoading;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFF1B4965), // Dark blue matching sidebar
            const Color(0xFF296992), // Medium blue
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B4965).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _submitForm(context),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        FontAwesomeIcons.paperPlane,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        "Send Message",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _submitForm(BuildContext context) {
    // Since validation is removed due to CustomFormTextField limitations,
    // you can add basic validation here if needed
    context.read<ContactCubit>().contact();
  }

  void _launchEmail(String email) {
    // Implementation for launching email client
    // You can use url_launcher package for this
  }
}
