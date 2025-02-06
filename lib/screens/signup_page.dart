import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/screens/adiology_center_details.dart';
import 'package:graduation_project_frontend/screens/hello_page.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

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
  // String? email, password;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final TextEditingController contactNumberController = TextEditingController();

  // final TextEditingController specializationController = TextEditingController();
  final TextEditingController centerNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController specializationController =
      TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  //method
  // void register() {
  //   if (selectedRole == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("برجاء اختيار دور المستخدم")),
  //     );
  //     print("no role");
  //     return;
  //   }
  //   final registerCubit = context.read<RegisterCubit>();
  //   print(emailController.text);
  //   registerCubit.registerUser(
  //     emailController.text,
  //     passwordController.text,
  //     selectedRole!, // ✅ نرسل الدو
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: sky,
      //padding from left and right to make form in middle of right side
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is RegisterSuccess) {
              print("RegisterSuccess");
              // if (state.role == "Technician") {
              //   print("Technician");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => 
                    //HelloPage(), 
                    SummaryPage(
                      email: emailController.text,
                      role: selectedRole!,
                      //address: addressController.text,
                      contactNumber: contactNumberController.text,
                    ),
                    //SummaryPage(state.userId),
                  ),
                );
              //}
              // else if (state.role == "Doctor") {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DoctorDetails(state.userId),
              //   ),
              // );
            }
          },
          builder: (context, state) {
            if (state is RegisterLoading) {
              isLoading = true;
              return Center(child: CircularProgressIndicator());
            } else if (state is RegisterSuccess) {
              // || state is RegisterFailure
              isLoading = false;
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => HelloPage(),
                  // SummaryPage(
                  //   email: emailController.text,
                  //   role: selectedRole!,
                  //   address: addressController.text,
                  //   contactNumber: contactNumberController.text,
                  // ),
                  //SummaryPage(state.userId),
                //),
            // );
            }

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
                            width: 200),
                      ),
                    ),
                  ),
                  //right side
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 46),
                      child: ListView(
                        children: [
                          const SizedBox(
                            height: 75,
                          ),
                          //header
                          Text("Get Started Now",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              // CustomFormTextField(
                              //   hintText: "Full Name",
                              //   icon: Icons.person,
                              //   controller: centerNameController,
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
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
                                // onChanged: (data) {
                                //   email = data;
                                // },
                                hintText: 'Enter your email',
                                icon: Icons.email,
                                controller: emailController,
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 10,
                          ),
                          // Dropdown for Role Selection
                          Padding(
                            padding: EdgeInsets.only(bottom: 10),
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
                              controller: specializationController,
                            ),
                            CustomFormTextField(
                              hintText: 'Enter your first name',
                              icon: Icons.medical_services,
                              controller: firstNameController,
                            ),
                            const SizedBox(
                                height: 10,
                              ),
                            CustomFormTextField(
                              hintText: 'Enter your last name',
                              icon: Icons.medical_services,
                              controller: lastNameController,
                            ),
                            const SizedBox(
                                height: 10,
                              ),
                              CustomFormTextField(
                              hintText: 'Enter your contact no.',
                              icon: Icons.work,
                              controller: contactNumberController,
                            ),
                          ],
                          if (selectedRole == "Technician") ...[
                            CustomFormTextField(
                                hintText: "Center Name",
                                icon: Icons.person,
                                controller: centerNameController,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            CustomFormTextField(
                              hintText: 'Enter your address',
                              icon: Icons.work,
                              controller: addressController,
                            ),
                            const SizedBox(
                                height: 10,
                              ),
                            CustomFormTextField(
                              hintText: 'Enter your contact no.',
                              icon: Icons.work,
                              controller: contactNumberController,
                            ),
                          ],

                          SizedBox(height: 20),
                          CustomFormTextField(
                              obscureText: true, //to hide password
                              // onChanged: (data) {
                              //   password = data;
                              // },
                              hintText: 'Set your password',
                              icon: Icons.lock,
                              controller: passwordController),
                          const SizedBox(
                            height: 20,
                          ),

                          CustomFormTextField(
                              hintText: "Confirm Password",
                              icon: Icons.lock,
                              obscureText: true),

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
                                  if (states.contains(MaterialState.selected)) {
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

                          CustomButton(
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                // register();
                                print(selectedRole);
                                print(centerNameController.text.toString());
                                print(addressController.text.toString());
                                print(contactNumberController.text.toString());
                               // print(emailController.text.toString());
                                // print(emailController);
                                // context
                                //     .read<RegisterCubit>()
                                //     .emit(CompleteRegistrationSuccess());
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) =>
                                //           RadiologyCenterDetails(userId)), // ✅ الانتقال للصفحة
                                // );
                                if (selectedRole == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("برجاء اختيار دور المستخدم")),
                                  );
                                  return;
                                }
                                final registerCubit =
                                    context.read<RegisterCubit>();
                                 String? userId ; 
                                if (selectedRole == "Technician") {
                                    userId = await registerCubit.registerUser(
                                  emailController.text,
                                  passwordController.text,
                                  selectedRole!,
                                  addressController.text,
                                  contactNumberController.text,
                                  centerNameController.text,
                                );
                                }else if(selectedRole == "Doctor"){
                                        userId = await registerCubit.registerDoctor(
                                  emailController.text,
                                  passwordController.text,
                                  selectedRole!,
                                  specializationController.text,
                                  contactNumberController.text,
                                  firstNameController.text,
                                  lastNameController.text,
                                );
                                }
                                print("hiiiii");
                               // print(userId);
                                if (userId != null) {
                                  if (selectedRole == "Technician") {
                                    // context
                                    //   .read<RegisterCubit>()
                                    //   .emit(RegisterSuccess());
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>HelloPage(), 
                                        // SummaryPage(
                                        //   email: emailController.text,
                                        //   role: selectedRole!,
                                        //   address: addressController.text,
                                        //   contactNumber:
                                        //       contactNumberController.text,
                                        // ),
                                        // SummaryPage(userId),
                                      ),
                                    );
                                  } else if (selectedRole == "Doctor") {
                                    // TODO: انتقل إلى صفحة DoctorDetails بعد إنشائها
                                  }
                                } else {
                                  print("Registration failed");
                                }

                                // final response =
                                //     await register(); // تنفيذ عملية التسجيل

                                // if (response != null &&
                                //     response.containsKey("radiologyCenter")) {
                                //   String userId = response["radiologyCenter"]
                                //       ["_id"]; // ✅ استخراج الـ userId
                                //   context
                                //       .read<RegisterCubit>()
                                //       .emit(CompleteRegistrationSuccess());

                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             RadiologyCenterDetails(
                                //                 userId:
                                //                     userId)), // ✅ تمرير userId
                                //   );
                                // }
                              } else {}
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
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(builder: (context) {
                                  //     return SigninPage();
                                  //   }),
                                  // );
                                  // Navigator.pushNamed(context, 'SigninPage');
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
                          // const Spacer(
                          //   flex: 3,
                          // ),
                        ],
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
