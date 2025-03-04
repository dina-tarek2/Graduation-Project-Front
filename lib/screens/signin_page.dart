import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/forget_password.dart';
import 'package:graduation_project_frontend/screens/doctor_home_page.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';

// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class SigninPage extends StatefulWidget {
  static String id = 'SigninPage';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isLoading = false;
  bool isChecked = false;
  // To check if the checkbox is selected
  GlobalKey<FormState> formKey1 = GlobalKey();
  GlobalKey<FormState> formKey2 = GlobalKey();

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: sky,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: formKey1,
          child: Row(
            children: [
              //left side which is photo
              Expanded(
                child: Container(
                  color: sky,
                  child: Center(
                    child:
                        Image.asset("assets/images/Doctor-bro.png", width: 700),
                  ),
                ),
              ),
              //right side
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: sky,
                    image: DecorationImage(
                      image: AssetImage("assets/images/image 5.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 46),
                    child: ListView(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                          child: Text("Welcome Back",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BlocConsumer<LoginCubit, LoginState>(
                              listener: (context, state) {
                                if (state is LoginLoading) {
                                  CircularProgressIndicator();
                                }
                                if (state is LoginSuccess) {
                                  if (state.role == "RadiologyCenter") {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MainScaffold(role: "RadiologyCenter"),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "You Login As Radiology Canter Welcome to Rad Assist"),
                                        backgroundColor: Colors.green.shade400,
                                      ),
                                    );
                                    Navigator.pushReplacementNamed(
                                        context, HomePage.id);
                                  } else if (state.role == "Radiologist") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            "You Login As Radiologist Welcome to Rad Assist"),
                                        backgroundColor: Colors.green.shade400,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MainScaffold(role: "Radiologist"),
                                      ),
                                    );
                                  }
                                } else if (state is LoginError) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ));
                                }
                              },
                              builder: (context, state) {
                                return Form(
                                  key: BlocProvider.of<LoginCubit>(context)
                                      .loginKey,
                                  child: Column(
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
                                        controller:
                                            BlocProvider.of<LoginCubit>(context)
                                                .emailController,
                                        hintText: 'Enter your email',
                                        validator: (value) {
                                          if (!RegExp(
                                                  r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
                                              .hasMatch(value!)) {
                                            return 'Please enter your email';
                                          } else if (!value.contains('@') ||
                                              !value.contains('.com')) {
                                            return 'Invalid email format';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                            BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, state) {
                                return CustomFormTextField(
                                  obscureText: BlocProvider.of<LoginCubit>(
                                          context)
                                      .isLoginPasswordShowing, //to hide password
                                  controller:
                                      BlocProvider.of<LoginCubit>(context)
                                          .passwordController,
                                  hintText: 'Enter your password',
                                  icon: Icons.lock,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your password';
                                    } else if (value.length < 6) {
                                      return 'Password must be at least 6 characters';
                                    }
                                    return null;
                                  },
                                  suffixIcon: Icon(
                                      BlocProvider.of<LoginCubit>(context)
                                          .suffixIcon),
                                  suffixIconOnPressed: () {
                                    BlocProvider.of<LoginCubit>(context)
                                        .changeLoginPasswordSuffixIcon();
                                  },
                                );
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // Checkbox for remember me
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      value: isChecked,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          isChecked = value!;
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isChecked = !isChecked;
                                        });
                                      },
                                      child: Text("Remeber me"),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context, ForgetPassword.id);
                                  },
                                  child: const Text(
                                    'Forget Password',
                                    style: TextStyle(
                                      color: blue,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            BlocBuilder<LoginCubit, LoginState>(
                              builder: (context, state) {
                                return CustomButton(
                                  onTap: () async {
                                    if (formKey1.currentState!.validate()) {}
                                    context.read<LoginCubit>().login();
                                  },
                                  text: 'Sign In',
                                );
                              },
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

                            CustomButton(text: "Sign in with Google"),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, SignupPage.id);
                              },
                              child: const Text(
                                ' Create One',
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
        ),
      ),
    );
  }
}
