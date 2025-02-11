import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/register_cubit.dart';
import 'package:graduation_project_frontend/cubit/register_state.dart';
import 'package:graduation_project_frontend/screens/signin_page.dart';

class VerifyOtpPage extends StatefulWidget {
  final Map<String, dynamic> registerData;
  final String role;

  VerifyOtpPage({required this.registerData, required this.role});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Verfiy OTP")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("OTP is sent to ${widget.registerData['email']}"),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(labelText: "Please Insert OTP here"),
            ),
            SizedBox(height: 20),
            BlocConsumer<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Registered Successfully")),
                  );
                   Navigator.pushNamed(context, SigninPage.id);
                } else if (state is RegisterFailure) {
                  //
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.error)),
                  );
                }
              },
              builder: (context, state) {
                if (state is OtpVerifying) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    final otp = otpController.text.trim();
                    if (otp.isNotEmpty) {
                      context.read<RegisterCubit>().verifyOtp(otp,widget.role);
                    }
                  },
                  child: Text("Verify"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
