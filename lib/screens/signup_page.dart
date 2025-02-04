import 'package:flutter/material.dart';
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
  // To check if the checkbox is selected
  bool isChecked = false;
  GlobalKey<FormState> formKey = GlobalKey();

  String? email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: sky,
      //padding from left and right to make form in middle of right side
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
                        Image.asset("assets/images/Doctor-bro.png", width: 200),
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

                          CustomFormTextField(
                            hintText: "Full Name",
                            icon: Icons.person,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
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
                            onChanged: (data) {
                              email = data;
                            },
                            hintText: 'Enter your email',
                            icon: Icons.email,
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

                      CustomFormTextField(
                          obscureText: true, //to hide password
                          onChanged: (data) {
                            password = data;
                          },
                          hintText: 'Set your password',
                          icon: Icons.lock),
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
                            fillColor: MaterialStateProperty.resolveWith<Color>(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) {
                                  return SigninPage();
                                }),
                              );
                              Navigator.pushNamed(context, 'SigninPage');
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
        ),
      ),
    );
  }
}
