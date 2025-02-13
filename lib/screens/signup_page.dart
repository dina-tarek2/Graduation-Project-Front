import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/screens/verify_otp_page.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/constants/colors.dart';

class SignupPage extends StatefulWidget {
  static String id = 'SignupPage';

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isLoading = false;
  String? selectedRole; // To store the selected role
  bool isChecked = false; // To check if the checkbox is selected
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //padding from left and right to make form in middle of right side
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            // TODO: implement listener
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
                  //left side which is photo
                  Expanded(
                    child: Container(
                      color: sky,
                      child: Center(
                        child: Image.asset("assets/images/Doctor-bro.png",
                            width: 700),
                      ),
                    ),
                  ),
                  //right side
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: sky,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/image 5.png",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 46),
                        child: ListView(
                          children: [
                            const SizedBox(
                              height: 75,
                            ),
                            Text("Get Started Now",
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold)),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                //if i want to show word above box
                                // Container(
                                //   alignment:
                                //       Alignment.centerLeft, // Align text to the left
                                //   child: Text(
                                //     'Email',
                                //     style: TextStyle(
                                //       fontSize: 24,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                CustomFormTextField(
                                  hintText: 'Enter your email',
                                  icon: Icons.email,
                                  controller: context
                                      .read<RegisterCubit>()
                                      .emailController,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // Dropdown for Role Selection
                            Padding(
                              // padding: EdgeInsets.only(bottom: 10),
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
                                  });
                                },
                              ),
                            ),
                            // Conditional fields based on selected role
                            if (selectedRole == "Doctor") ...[
                              CustomFormTextField(
                                hintText: 'Enter your specialization',
                                icon: Icons.medical_services,
                                controller: context
                                    .read<RegisterCubit>()
                                    .specializationController,
                              ),
                              CustomFormTextField(
                                hintText: 'Enter your first name',
                                icon: Icons.medical_services,
                                controller: context
                                    .read<RegisterCubit>()
                                    .firstNameController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              CustomFormTextField(
                                hintText: 'Enter your last name',
                                icon: Icons.medical_services,
                                controller: context
                                    .read<RegisterCubit>()
                                    .lastNameController,
                              ),
                              CustomFormTextField(
                                hintText: 'Enter your contact no.',
                                icon: Icons.work,
                                controller: context
                                    .read<RegisterCubit>()
                                    .contactNumberController,
                              ),
                            ],
                            if (selectedRole == "Technician") ...[
                              CustomFormTextField(
                                hintText: "Center Name",
                                icon: Icons.person,
                                controller: context
                                    .read<RegisterCubit>()
                                    .centerNameController,
                              ),
                              CustomFormTextField(
                                hintText: 'Enter your address',
                                icon: Icons.work,
                                controller: context
                                    .read<RegisterCubit>()
                                    .addressController,
                              ),
                              CustomFormTextField(
                                hintText: 'Enter your contact no.',
                                icon: Icons.work,
                                controller: context
                                    .read<RegisterCubit>()
                                    .contactNumberController,
                              ),
                            ],
                            SizedBox(height: 20),
                            CustomFormTextField(
                              obscureText:
                                  BlocProvider.of<RegisterCubit>(context)
                                      .isRegisterPasswordShowing,
                              //to hide password
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
                            const SizedBox(
                              height: 20,
                            ),
                            CustomFormTextField(
                              hintText: "Confirm Password",
                              icon: Icons.lock,
                              suffixIcon: Icon(
                                  BlocProvider.of<RegisterCubit>(context)
                                      .suffixIcon),
                              suffixIconOnPressed: () {
                                BlocProvider.of<RegisterCubit>(context)
                                    .changeRegisterPasswordSuffixIcon();
                              },
                              obscureText:
                                  BlocProvider.of<RegisterCubit>(context)
                                      .isRegisterPasswordShowing,
                            ),

                            const SizedBox(
                              height: 20,
                            ),
                            // Checkbox for agree to terms
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                  //to change default color of checkbox from purple to blue
                                  fillColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (Set<MaterialState> states) {
                                    if (states
                                        .contains(MaterialState.selected)) {
                                      return blue; //when click on it
                                    }
                                    return Colors.white; //on default
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
                                        final registerCubit =
                                            context.read<RegisterCubit>();
                                        registerCubit.register(selectedRole!);
                                      }
                                    },
                                    text: 'Sign up',
                                  ),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1, // thickness
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          8.0), // distance between line and text
                                  child: Text(
                                    'or',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            CustomButton(text: "Sign up with Google"),
                            const SizedBox(
                              height: 10,
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                //navigation
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
      ),
    );
  }
}
