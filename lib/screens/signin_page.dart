import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/dicom_list_page.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
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
  GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: sky,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Form(
          key: formKey,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 46),
                  child: ListView(
                    children: [
                      const SizedBox(
                        height: 75,
                      ),
                      const Row(
                        children: [
                          Text("Welcome Back",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      BlocConsumer<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Login Successful")));
                                 Navigator.pushReplacementNamed(context, DicomListPage.id);
                            //Navigate to another screen after success
                          } else if (state is LoginError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)));
                          }
                        },
                        builder: (context, state) {
                          return Form(
                            key: BlocProvider.of<LoginCubit>(context).loginKey,
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
                                  icon: Icons.email,
                                  // validator: (data) {
                                  //   if (data!.isEmpty |
                                  //       data.contains('@gmail.com')) {
                                  //     return 'this Email is invalid must be contain @gmail.com ';
                                  //   }
                                  // }
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          return CustomFormTextField(
                            obscureText: BlocProvider.of<LoginCubit>(context)
                                .isLoginPasswordShowing, //to hide password
                            controller: BlocProvider.of<LoginCubit>(context)
                                .passwordController,
                            hintText: 'Enter your password',
                            icon: Icons.lock,
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
                                child: Text("Remeber me"),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            'Forget Password',
                            style: TextStyle(
                              color: blue,
                            ),
                          ),
                        ],
                      ),

                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                           if (state is LoginLoading) {
                          return Center(child: CircularProgressIndicator());
                        }
                          return CustomButton(
                            onTap: () async {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return SignupPage();
                                }),
                              );
                              Navigator.pushNamed(context, 'SignupPage');
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
                      // const Spacer(
                      //   flex: 3,
                      // ),
                    ],
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
