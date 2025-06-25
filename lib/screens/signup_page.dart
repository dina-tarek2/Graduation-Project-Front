import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/screens/verify_otp_page.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

class SignupPage extends StatefulWidget {
  static String id = 'SignupPage';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> with TickerProviderStateMixin {
  bool isLoading = false;
  String? selectedRole;
  bool isChecked = false;
  GlobalKey<FormState> formKey = GlobalKey();

  String? frontIdFileName;
  String? backIdFileName;
  File? frontIdFile;
  File? backIdFile;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<String> availableSpecializations = [
    'Chest Radiology',
    'Abdominal Radiology',
    'Head and Neck Radiology',
    'Musculoskeletal Radiology',
    'Neuroradiology',
    'Thoracic Radiology',
    'Cardiovascular Radiology',
  ];

  List<String> selectedSpecializations = [];
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _pickFrontIdImage() async {
    await context.read<RegisterCubit>().pickFrontIdImage();
    setState(() {
      frontIdFile = context.read<RegisterCubit>().frontIdFile;
      frontIdFileName = frontIdFile?.path.split(Platform.pathSeparator).last;
    });
  }

  void _pickBackIdImage() async {
    await context.read<RegisterCubit>().pickBackIdImage();
    setState(() {
      backIdFile = context.read<RegisterCubit>().backIdFile;
      backIdFileName = backIdFile?.path.split(Platform.pathSeparator).last;
    });
  }

  void _removeFrontIdImage() {
    context.read<RegisterCubit>().removeFrontIdImage();
    setState(() {
      frontIdFile = null;
      frontIdFileName = null;
    });
  }

  void _removeBackIdImage() {
    context.read<RegisterCubit>().removeBackIdImage();
    setState(() {
      backIdFile = null;
      backIdFileName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is OtpVerfication) {
            _showOtpDialog(state);
          } else if (state is RegisterFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              decoration: _buildGradientBackground(),
              child: Row(
                children: [
                  _buildLeftPanel(),
                  _buildRightPanel(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          blue.withOpacity(0.1),
          Colors.white,
          blue.withOpacity(0.05),
        ],
      ),
    );
  }

  Widget _buildLeftPanel() {
    return Expanded(
      flex: 5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(5, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/signInDoc2.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      blue.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 40,
                right: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Join Our Medical",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      "Community",
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Connect with healthcare professionals worldwide and advance your medical career.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(RegisterState state) {
    return Expanded(
      flex: 4,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: Offset(-10, 0),
              ),
            ],
          ),
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: ListView(
                children: [
                  _buildHeader(),
                  SizedBox(height: 40),
                  _buildProgressIndicator(),
                  SizedBox(height: 30),
                  _buildFormContent(state),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(
            Icons.medical_services,
            color: blue,
            size: 30,
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Create Account",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Join our platform and start your journey",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          _buildProgressStep(0, "Basic Info", Icons.person),
          _buildProgressConnector(0),
          _buildProgressStep(1, "Role", Icons.work),
          _buildProgressConnector(1),
          _buildProgressStep(2, "Complete", Icons.check_circle),
        ],
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, IconData icon) {
    bool isActive = currentStep >= step;
    bool isCurrent = currentStep == step;

    return Expanded(
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive ? blue : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCurrent ? blue : Colors.transparent,
                width: 3,
              ),
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey.shade500,
              size: 20,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? blue : Colors.grey.shade500,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressConnector(int step) {
    bool isActive = currentStep > step;
    return Expanded(
      child: Container(
        height: 2,
        margin: EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: isActive ? blue : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }

  Widget _buildFormContent(RegisterState state) {
    return Column(
      children: [
        _buildBasicInfoFields(),
        SizedBox(height: 20),
        _buildRoleSelection(),
        if (selectedRole != null) ...[
          SizedBox(height: 20),
          _buildRoleSpecificFields(),
        ],
        SizedBox(height: 30),
        _buildPasswordField(),
        SizedBox(height: 25),
        _buildTermsCheckbox(),
        SizedBox(height: 30),
        _buildSignUpButton(state),
        SizedBox(height: 20),
        _buildSignInLink(),
      ],
    );
  }

  Widget _buildBasicInfoFields() {
    return Column(
      children: [
        _buildAnimatedTextField(
          controller: context.read<RegisterCubit>().emailController,
          hintText: 'Enter your email address',
          icon: Icons.email_outlined,
          delay: 100,
        ),
        SizedBox(height: 16),
        _buildAnimatedTextField(
          controller: context.read<RegisterCubit>().contactNumberController,
          hintText: 'Contact number',
          icon: Icons.phone_outlined,
          delay: 200,
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required int delay,
    bool obscureText = false,
    Widget? suffixIcon,
    VoidCallback? suffixIconOnPressed,
  }) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 500 + delay),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: TextFormField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: hintText,
                  prefixIcon: Icon(icon, color: blue),
                  suffixIcon: suffixIcon != null
                      ? IconButton(
                          icon: suffixIcon,
                          onPressed: suffixIconOnPressed,
                        )
                      : null,
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: blue, width: 2),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRoleSelection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedRole,
        decoration: InputDecoration(
          labelText: "Select your role",
          prefixIcon: Icon(Icons.work_outline, color: blue),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: blue, width: 2),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        items: ["Doctor", "Technician"].map((role) {
          return DropdownMenuItem<String>(
            value: role,
            child: Text(role),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            selectedRole = value;
            currentStep = value != null ? 1 : 0;
            if (value != "Doctor") {
              selectedSpecializations.clear();
              frontIdFileName = null;
              backIdFileName = null;
              frontIdFile = null;
              backIdFile = null;
            }
          });
        },
      ),
    );
  }

  Widget _buildRoleSpecificFields() {
    if (selectedRole == "Doctor") {
      return _buildDoctorFields();
    } else if (selectedRole == "Technician") {
      return _buildTechnicianFields();
    }
    return SizedBox.shrink();
  }

  Widget _buildDoctorFields() {
    return Column(
      children: [
        _buildModernSpecializationSelector(),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedTextField(
                controller: context.read<RegisterCubit>().firstNameController,
                hintText: 'First name',
                icon: Icons.person_outline,
                delay: 300,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildAnimatedTextField(
                controller: context.read<RegisterCubit>().lastNameController,
                hintText: 'Last name',
                icon: Icons.person_outline,
                delay: 400,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildModernIdPhotoUpload(
          title: "Front ID Photo",
          fileName: frontIdFileName,
          onTap: _pickFrontIdImage,
          onRemove: _removeFrontIdImage,
          icon: Icons.credit_card,
        ),
        SizedBox(height: 16),
        _buildModernIdPhotoUpload(
          title: "Back ID Photo",
          fileName: backIdFileName,
          onTap: _pickBackIdImage,
          onRemove: _removeBackIdImage,
          icon: Icons.credit_card,
        ),
      ],
    );
  }

  Widget _buildTechnicianFields() {
    return Column(
      children: [
        _buildAnimatedTextField(
          controller: context.read<RegisterCubit>().centerNameController,
          hintText: "Medical center name",
          icon: Icons.business_outlined,
          delay: 300,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedTextField(
                controller: context.read<RegisterCubit>().streetController,
                hintText: 'Street address',
                icon: Icons.location_on_outlined,
                delay: 400,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildAnimatedTextField(
                controller: context.read<RegisterCubit>().cityController,
                hintText: 'City',
                icon: Icons.location_city_outlined,
                delay: 500,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildAnimatedTextField(
                controller: context.read<RegisterCubit>().stateController,
                hintText: 'State',
                icon: Icons.map_outlined,
                delay: 600,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildAnimatedTextField(
                controller: context.read<RegisterCubit>().zipcodeController,
                hintText: 'ZIP code',
                icon: Icons.local_post_office_outlined,
                delay: 700,
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        _buildLicenseUpload(),
      ],
    );
  }

  Widget _buildPasswordField() {
    return _buildAnimatedTextField(
      controller: context.read<RegisterCubit>().passwordController,
      hintText: 'Create a strong password',
      icon: Icons.lock_outline,
      delay: 800,
      obscureText:
          BlocProvider.of<RegisterCubit>(context).isRegisterPasswordShowing,
      suffixIcon: Icon(BlocProvider.of<RegisterCubit>(context).suffixIcon),
      suffixIconOnPressed: () {
        BlocProvider.of<RegisterCubit>(context)
            .changeRegisterPasswordSuffixIcon();
      },
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value!;
              });
            },
            activeColor: blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                isChecked = !isChecked;
              });
            },
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                children: [
                  TextSpan(text: "I agree to the "),
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(
                      color: blue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: blue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpButton(RegisterState state) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [blue, blue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: blue.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: state is RegisterLoading
          ? Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              ),
            )
          : Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: _handleSignUp,
                child: Center(
                  child: Text(
                    'Create Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 14,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, SigninPage.id);
          },
          child: Text(
            'Sign In',
            style: TextStyle(
              color: blue,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSpecializationSelector() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white,
      ),
      child: ExpansionTile(
        leading: Icon(Icons.medical_services, color: blue),
        title: Text(
          selectedSpecializations.isEmpty
              ? "Select Specializations"
              : "${selectedSpecializations.length} specialization(s) selected",
          style: TextStyle(
            fontSize: 16,
            color: selectedSpecializations.isEmpty
                ? Colors.grey.shade600
                : Colors.black87,
          ),
        ),
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: availableSpecializations.map((specialization) {
                final isSelected =
                    selectedSpecializations.contains(specialization);
                return Container(
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isSelected
                        ? blue.withOpacity(0.1)
                        : Colors.grey.shade50,
                    border: Border.all(
                      color: isSelected ? blue : Colors.grey.shade200,
                    ),
                  ),
                  child: CheckboxListTile(
                    title: Text(
                      specialization,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                        color: isSelected ? blue : Colors.black87,
                      ),
                    ),
                    value: isSelected,
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedSpecializations.add(specialization);
                        } else {
                          selectedSpecializations.remove(specialization);
                        }
                        if (selectedSpecializations.isNotEmpty) {
                          currentStep = 2;
                        }
                      });
                    },
                    activeColor: blue,
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernIdPhotoUpload({
    required String title,
    required String? fileName,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required IconData icon,
  }) {
    final bool hasFile = fileName != null;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFile ? blue : Colors.grey.shade200,
          width: hasFile ? 2 : 1,
        ),
        color: Colors.white,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:
                        hasFile ? blue.withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    hasFile ? Icons.check_circle : icon,
                    color: hasFile ? blue : Colors.grey.shade500,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: hasFile ? blue : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        hasFile ? fileName! : "Tap to upload image",
                        style: TextStyle(
                          fontSize: 14,
                          color: hasFile
                              ? Colors.green.shade600
                              : Colors.grey.shade500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (hasFile)
                  IconButton(
                    onPressed: onRemove,
                    icon: Icon(Icons.close, color: Colors.red.shade400),
                  )
                else
                  Icon(Icons.cloud_upload_outlined,
                      color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLicenseUpload() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final hasLicense =
            context.read<RegisterCubit>().licenseImageFile != null;
        final fileName = hasLicense
            ? context
                .read<RegisterCubit>()
                .licenseImageFile!
                .path
                .split(Platform.pathSeparator)
                .last
            : null;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasLicense ? blue : Colors.grey.shade200,
              width: hasLicense ? 2 : 1,
            ),
            color: Colors.white,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => context.read<RegisterCubit>().pickLicenseImage(),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: hasLicense
                            ? blue.withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        hasLicense
                            ? Icons.check_circle
                            : Icons.verified_user_outlined,
                        color: hasLicense ? blue : Colors.grey.shade500,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Radiology Practice License",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: hasLicense ? blue : Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            hasLicense ? fileName! : "Upload license image",
                            style: TextStyle(
                              fontSize: 14,
                              color: hasLicense
                                  ? Colors.green.shade600
                                  : Colors.grey.shade500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.cloud_upload_outlined,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleSignUp() async {
    if (!formKey.currentState!.validate()) return;

    if (!isChecked) {
      _showErrorSnackBar("Please accept the terms and conditions");
      return;
    }

    if (selectedRole == null) {
      _showErrorSnackBar("Please select your role");
      return;
    }

    if (selectedRole == "Doctor") {
      if (selectedSpecializations.isEmpty) {
        _showErrorSnackBar("Please select at least one specialization");
        return;
      }
      if (frontIdFileName == null) {
        _showErrorSnackBar("Please upload front ID photo");
        return;
      }
      if (backIdFileName == null) {
        _showErrorSnackBar("Please upload back ID photo");
        return;
      }
    }

    if (selectedRole == "Technician") {
      if (context.read<RegisterCubit>().licenseImageFile == null) {
        _showErrorSnackBar("Please upload your practice license");
        return;
      }
    }

    final registerCubit = context.read<RegisterCubit>();
    registerCubit.register(
      selectedRole!,
      specializations: selectedSpecializations,
      frontIdImage: frontIdFile,
      backIdImage: backIdFile,
    );
  }

  void _showOtpDialog(OtpVerfication state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: VerifyOtpPage(
              message: state.message,
              role: selectedRole!,
            ),
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 4),
      ),
    );
  }
}
