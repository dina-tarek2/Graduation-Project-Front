import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';

class VerifyOtpPage extends StatefulWidget {
  final String role;
  final String message;

  const VerifyOtpPage({super.key, required this.role, required this.message});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.red, size: 28),
              onPressed: () => Navigator.pop(context), 
            ),
          ),

          Text(
            widget.message,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold, 
              color: blue,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),

          CustomFormTextField(
            controller: otpController,
            hintText: "Enter OTP here",
            width: 280,
          ),
          SizedBox(height: 20),

          BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                Navigator.pop(context); 
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Registered Successfully")),
                );
                Navigator.pushReplacementNamed(context, SigninPage.id);
              } else if (state is RegisterFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
              if (state is OtpVerifying) {
                return CircularProgressIndicator();
              }
              return CustomButton(
                width: 140,
                text: "Verify",
                onTap: () async {
                  final otp = otpController.text.trim();
                  if (otp.isNotEmpty) {
                    await context.read<RegisterCubit>().verifyOtp(otp, widget.role);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
