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

class _SignupPageState extends State<SignupPage> {
  bool isLoading = false;
  String? selectedRole;
  bool isChecked = false;
  GlobalKey<FormState> formKey = GlobalKey();

  String? frontIdFileName;
  String? backIdFileName;
  File? frontIdFile;
  File? backIdFile;
  final ImagePicker _picker = ImagePicker();

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
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: VerifyOtpPage(
                      message: state.message,
                      role: selectedRole!,
                    ),
                  ),
                );
              },
            );
          } else if (state is RegisterFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Form(
            key: formKey,
            child: Row(
              children: [
                // Left side - photo
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/signInDoc2.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                // Right side - form
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: blue,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(45.0),
                        topLeft: Radius.circular(45.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 46),
                      child: ListView(
                        children: [
                          const SizedBox(height: 75),
                          Text("Get Started Now",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 20),

                          // Email field
                          Column(
                            children: [
                              CustomFormTextField(
                                hintText: 'Enter your email',
                                icon: Icons.email,
                                controller: context
                                    .read<RegisterCubit>()
                                    .emailController,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          CustomFormTextField(
                            hintText: 'Contact No.',
                            icon: Icons.phone,
                            controller: context
                                .read<RegisterCubit>()
                                .contactNumberController,
                          ),
                          const SizedBox(height: 10),

                          // Role Selection Dropdown
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: DropdownButtonFormField<String>(
                              value: selectedRole,
                              decoration: InputDecoration(
                                labelText: "Role",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
                                  // Reset specializations when role changes
                                  if (value != "Doctor") {
                                    selectedSpecializations.clear();
                                    // Reset ID photos when changing from Doctor
                                    frontIdFileName = null;
                                    backIdFileName = null;
                                    frontIdFile = null;
                                    backIdFile = null;
                                  }
                                });
                              },
                            ),
                          ),

                          // Conditional fields based on selected role
                          if (selectedRole == "Doctor") ...[
                            const SizedBox(height: 10),

                            // Modern Specialization Multi-Select Widget
                            _buildSpecializationSelector(),

                            const SizedBox(height: 10),
                            CustomFormTextField(
                              hintText: 'Enter your first name',
                              icon: Icons.person,
                              controller: context
                                  .read<RegisterCubit>()
                                  .firstNameController,
                            ),
                            const SizedBox(height: 10),
                            CustomFormTextField(
                              hintText: 'Enter your last name',
                              icon: Icons.person_outline,
                              controller: context
                                  .read<RegisterCubit>()
                                  .lastNameController,
                            ),

                            const SizedBox(height: 15),

                            // Front ID Photo Upload
                            _buildIdPhotoUpload(
                              title: "Front ID Photo",
                              fileName: frontIdFileName,
                              onTap: _pickFrontIdImage,
                              onRemove: _removeFrontIdImage,
                              icon: Icons.credit_card,
                            ),

                            const SizedBox(height: 10),

                            // Back ID Photo Upload
                            _buildIdPhotoUpload(
                              title: "Back ID Photo",
                              fileName: backIdFileName,
                              onTap: _pickBackIdImage,
                              onRemove: _removeBackIdImage,
                              icon: Icons.credit_card_off,
                            ),
                          ],

                          if (selectedRole == "Technician") ...[
                            CustomFormTextField(
                              hintText: "Center Name",
                              icon: Icons.business,
                              controller: context
                                  .read<RegisterCubit>()
                                  .centerNameController,
                            ),
                            CustomFormTextField(
                              hintText: 'Street',
                              icon: Icons.location_on,
                              controller: context
                                  .read<RegisterCubit>()
                                  .streetController,
                            ),
                            CustomFormTextField(
                              hintText: 'City',
                              icon: Icons.location_city,
                              controller:
                                  context.read<RegisterCubit>().cityController,
                            ),
                            CustomFormTextField(
                              hintText: 'State',
                              icon: Icons.map,
                              controller:
                                  context.read<RegisterCubit>().stateController,
                            ),
                            CustomFormTextField(
                              hintText: 'Zipcode',
                              icon: Icons.local_post_office,
                              controller: context
                                  .read<RegisterCubit>()
                                  .zipcodeController,
                            ),
                            InkWell(
                              onTap: () => context
                                  .read<RegisterCubit>()
                                  .pickLicenseImage(),
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(width: 8),
                                    BlocBuilder<RegisterCubit, RegisterState>(
                                      builder: (context, state) {
                                        return Text(
                                          context
                                                      .read<RegisterCubit>()
                                                      .licenseImageFile ==
                                                  null
                                              ? "Upload Radiology Practice License Image"
                                              : context
                                                  .read<RegisterCubit>()
                                                  .licenseImageFile!
                                                  .path
                                                  .split(Platform.pathSeparator)
                                                  .last,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Password field
                          CustomFormTextField(
                            obscureText: BlocProvider.of<RegisterCubit>(context)
                                .isRegisterPasswordShowing,
                            hintText: 'Set your password',
                            icon: Icons.lock,
                            suffixIcon: Icon(
                                BlocProvider.of<RegisterCubit>(context)
                                    .suffixIcon),
                            suffixIconOnPressed: () {
                              BlocProvider.of<RegisterCubit>(context)
                                  .changeRegisterPasswordSuffixIcon();
                            },
                            controller: context
                                .read<RegisterCubit>()
                                .passwordController,
                          ),

                          const SizedBox(height: 20),

                          // Terms checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                                fillColor:
                                    WidgetStateProperty.resolveWith<Color>(
                                        (Set<WidgetState> states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return blue;
                                  }
                                  return Colors.white;
                                }),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: Text("I agree to Term & Condition"),
                              ),
                            ],
                          ),

                          // Sign up button
                          state is RegisterLoading
                              ? Center(child: CircularProgressIndicator())
                              : CustomButton(
                                  onTap: () async {
                                    if (formKey.currentState!.validate()) {
                                      if (selectedRole == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text("Please choose role")),
                                        );
                                        return;
                                      }

                                      if (selectedRole == "Doctor") {
                                        if (frontIdFileName == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Please upload front ID photo")),
                                          );
                                          return;
                                        }
                                        if (backIdFileName == null) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    "Please upload back ID photo")),
                                          );
                                          return;
                                        }

                                        print(
                                            "Selected Specializations: $selectedSpecializations");
                                        print(
                                            "Front ID Photo: $frontIdFileName");
                                        print("Back ID Photo: $backIdFileName");
                                      }

                                      // final registerCubit =
                                      //     context.read<RegisterCubit>();
                                      // registerCubit.register(selectedRole!);
                                      final registerCubit =
                                          context.read<RegisterCubit>();

                                      registerCubit.register(
                                        selectedRole!,
                                        specializations:
                                            selectedSpecializations,
                                        frontIdImage: frontIdFile,
                                        backIdImage: backIdFile,
                                      );
                                    }
                                  },
                                  text: 'Sign up',
                                ),
                          const SizedBox(height: 10),

                          // Sign in link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, SigninPage.id);
                                },
                                child: const Text(
                                  ' Sign In',
                                  style: TextStyle(
                                    color: blue,
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildIdPhotoUpload({
    required String title,
    required String? fileName,
    required VoidCallback onTap,
    required VoidCallback onRemove,
    required IconData icon,
  }) {
    final bool hasFile = fileName != null;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasFile ? blue : Colors.grey.shade300,
              width: hasFile ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: hasFile
                    ? blue.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: hasFile ? blue.withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  hasFile ? Icons.check_circle : icon,
                  color: hasFile ? blue : Colors.grey.shade600,
                  size: 24,
                ),
              ),
              SizedBox(width: 12),
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
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                        fontWeight:
                            hasFile ? FontWeight.w500 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (hasFile)
                GestureDetector(
                  onTap: () {
                    // Simply call onRemove without parameters
                    onRemove();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.close,
                      color: Colors.red.shade600,
                      size: 20,
                    ),
                  ),
                )
              else
                Icon(
                  Icons.cloud_upload_outlined,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecializationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Icon(Icons.medical_services, color: Colors.grey.shade600),
              SizedBox(width: 12),
              Expanded(
                child: Text(
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
              ),
              Icon(Icons.medical_information, color: blue),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          child: Column(
            children: availableSpecializations.map((specialization) {
              final isSelected =
                  selectedSpecializations.contains(specialization);

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected ? blue.withOpacity(0.1) : Colors.white,
                  border: Border.all(
                    color: isSelected ? blue : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: blue.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: CheckboxListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  title: Text(
                    specialization,
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? blue : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedSpecializations.add(specialization);
                        print("Added: $specialization");
                      } else {
                        selectedSpecializations.remove(specialization);
                        print("Removed: $specialization");
                      }
                      print(
                          "Current Selected Specializations: $selectedSpecializations");
                    });
                  },
                  activeColor: blue,
                  checkColor: Colors.white,
                  controlAffinity: ListTileControlAffinity.leading,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (selectedSpecializations.isNotEmpty)
          Container(
            margin: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selected Specializations:",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: blue,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedSpecializations.map((specialization) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            blue.withOpacity(0.1),
                            blue.withOpacity(0.05)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: blue.withOpacity(0.3)),
                        boxShadow: [
                          BoxShadow(
                            color: blue.withOpacity(0.1),
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color: blue,
                          ),
                          SizedBox(width: 6),
                          Text(
                            specialization,
                            style: TextStyle(
                              color: blue,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedSpecializations.remove(specialization);
                              });
                              print("Removed from chips: $specialization");
                              print(
                                  "Updated Selected Specializations: $selectedSpecializations");
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: blue.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 12,
                                color: blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
