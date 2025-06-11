import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/forgetPassword/forget_passeord_cubit.dart';
import 'package:graduation_project_frontend/screens/resetPassword.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpResetpassword extends StatefulWidget {
  const OtpResetpassword({super.key});
  static String id = 'OtpResetpassword';
  @override
  State<OtpResetpassword> createState() => _OtpResetpasswordState();
}

class _OtpResetpasswordState extends State<OtpResetpassword> {
  String? savedEmail;

  @override
  void initState() {
    super.initState();
    loadSavedEmail();
  }

  void loadSavedEmail() async {
    String? email = await getEmail();
    if (email != null) {
      setState(() {
        savedEmail = email;
      });
    }
  }

  Future<void> saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('saved_email');
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
        listener: (context, state) {
          if (state is ForgetPasswordOtpUpdated) {
            showAdvancedNotification(
              context,
              message: "Otp Checked Susessfuly Go to reset Password Now ",
              type: NotificationType.success,
              style: AnimationStyle.card,
            );
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ResetPassword(),
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
        },
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
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
                                Icons.verified_outlined,
                                size: 100,
                                color: blue,
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 12),
                        Text("Verify OTP",
                            style: customTextStyle(
                                24, FontWeight.w600, Colors.black)),
                        SizedBox(height: 8),
                        if (savedEmail != null)
                          Text(
                            "Enter the 6-digit code sent to\n$savedEmail",
                            textAlign: TextAlign.center,
                            style: customTextStyle(
                                14, FontWeight.w400, Colors.blueGrey),
                          ),
                        SizedBox(height: 8),
                        // Text(
                        //     "Please enter the verification code sent to your email",
                        //     textAlign: TextAlign.center,
                        //     style: customTextStyle(
                        //         14, FontWeight.w300, Colors.blueGrey)),
                        OtpTextField(
                          showCursor: false,
                          numberOfFields: 6,
                          showFieldAsBox: true,
                          fieldWidth: 50,
                          filled: true,
                          // fillColor: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          focusedBorderColor: darkBabyBlue,
                          borderColor: blue,
                          onSubmit: (String verificationCode) {
                            print("OTP Submitted: $verificationCode");
                            context
                                .read<ForgetPasswordCubit>()
                                .updateOtp(verificationCode);
                          },
                        ),
                        if (state is ForgetPasswordLoading)
                          CircularProgressIndicator()
                        else
                          Column(
                            children: [
                              SizedBox(height: 10),
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .forgetPassword();
                                },
                                child: Text(
                                  "Didn't receive code? Resend",
                                  style: customTextStyle(18, FontWeight.w300,
                                      Colors.blue.shade700),
                                ),
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blue,
                                  fixedSize: Size(170, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  // Validate the form
                                  context
                                      .read<ForgetPasswordCubit>()
                                      .checkOtp();
                                },
                                child: Text(
                                  "Verify Code",
                                  style: customTextStyle(
                                      18, FontWeight.w300, Colors.white),
                                ),
                              ),
                            ],
                          )
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
