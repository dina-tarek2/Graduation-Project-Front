import 'package:flutter/material.dart'hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/forgetPassword/forget_passeord_cubit.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});
  static String id = 'ResetPassword';
  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}
class _ResetPasswordState extends State<ResetPassword> {
    bool _isPasswordObscured = true;
  @override
  Widget build(BuildContext context) {
      double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordReseted) {
           showAdvancedNotification(
            context,
            message: state.massage,
           type: NotificationType.success,
        style: AnimationStyle.card,
          );
           Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SigninPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); 
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 500),
  ),
);
          }
          if (state is ForgetPasswordFailure) {
          showAdvancedNotification(
        context,
        message: state.error,
        type: NotificationType.error,
        style: AnimationStyle.card,
          );
          }
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                color: Colors.white
                ),
              ),
               Positioned(
                top: 40,
                left: 16,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: blue, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: FractionallySizedBox(
                  widthFactor: screenWidth < 600 ? 0.95 : 0.6,
                  child: Container(
                    padding: EdgeInsets.all(20),
                   decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: blue,
                      blurRadius: 15,
                      spreadRadius: 5,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 500),
                              tween: Tween(begin: 0, end: 1),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Icon(
                                    Icons.password_outlined,
                                    size: 100,
                                    color: blue,
                                  ),
                                );
                              },
                            ),
                        SizedBox(height: 4),
                        Text("Reset Password",
                            style: customTextStyle(
                                24, FontWeight.w600, Colors.black)),
                        SizedBox(height: 4),
                        // Text(
                        //     "Please enter Yo",
                        //     textAlign: TextAlign.center,
                        //     style: customTextStyle(
                        //         14, FontWeight.w300, Colors.blueGrey)),
                        CustomFormTextField(
                            key: ValueKey('emailField'),
                          controller: context
                              .read<ForgetPasswordCubit>()
                              .emailController,
                          hintText: "Please Enter Your Email  ",
                          width: 250,
                        ),
                        CustomFormTextField(
                            key: ValueKey('passwordField'),
                          controller: context
                              .read<ForgetPasswordCubit>()
                              .newPasswordController,
                          hintText: "Enter Your New Password  ",
                          width: 250,
                           onSubmitted: (value) {
                                      context
                                          .read<ForgetPasswordCubit>()
                                          .ResetPassword();
                                  },
                          obscureText: _isPasswordObscured,
                         validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordObscured 
                                    ? FontAwesomeIcons.eyeSlash
                                    : FontAwesomeIcons.eye,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordObscured = !_isPasswordObscured;
                                  });
                                },
                              ),
                            ),
                        if (state is ForgetPasswordLoading)
                          CircularProgressIndicator()
                        else
                           ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            fixedSize: Size(190, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                                  onPressed: () {
                                    // Validate the form
                                 
                                      context
                                          .read<ForgetPasswordCubit>()
                                          .ResetPassword();
                                    },
                                  
                                  child: Text(
                                    "Reset Password",
                                  style: customTextStyle(
                                                 18, FontWeight.w300, Colors.white),
                                      ),
                                  ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
