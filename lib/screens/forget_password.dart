import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/forgetPassword/forget_passeord_cubit.dart';
import 'package:graduation_project_frontend/screens/otp_resetPassword.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});
  static String id = 'ForgetPassword';
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}



class _ForgetPasswordState extends State<ForgetPassword> {
  final formKey = GlobalKey<FormState>();
@override
  void initState() {
    super.initState();
    loadEmail();
  }

  Future<void> loadEmail() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email') ?? '';
    if (savedEmail.isNotEmpty) {
      final cubit = context.read<ForgetPasswordCubit>();
      cubit.emailController.text = savedEmail;
    }
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccess) {
          showAdvancedNotification(
            context,
            message: state.massage,
           type: NotificationType.success,
        style: AnimationStyle.glass,
          );
         
            Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => OtpResetpassword(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // من اليمين
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
        return Stack(fit: StackFit.expand, children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
          ),
          Positioned(
            top: screenHeight * 0.05,
            left: screenWidth * 0.03,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios, color: blue, size: 35),
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
                child: Form(
                  key: formKey,
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
                              Icons.lock_reset,
                              size: 80,
                              color: blue,
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 12),
                      Text("Forgot Password",
                          style: customTextStyle(
                              28, FontWeight.bold, Colors.black87)),

                      SizedBox(height: 12),

                      Text("Enter your email to reset your password",
                          textAlign: TextAlign.center,
                          style: customTextStyle(
                              16, FontWeight.w400, Colors.grey.shade600)),

                      SizedBox(height: 12),

                      CustomFormTextField(
                        controller:
                            context.read<ForgetPasswordCubit>().emailController,
                        hintText: " Your Email ",
                        width: 300,
                          onSubmitted: (value) {
                            context
                                  .read<ForgetPasswordCubit>()
                                  .ForgetPassword();                                  },
                      ),
                      if (state is ForgetPasswordLoading)
                        CircularProgressIndicator()
                      else
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: blue,
                            fixedSize: Size(150, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              context
                                  .read<ForgetPasswordCubit>()
                                  .ForgetPassword();
                            }
                          },
                          child: Text(
                            "Send OTP",
                            style: customTextStyle(
                                18, FontWeight.w300, Colors.white),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]);
      },
    ));
  }
}