import 'package:flutter/material.dart'hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/login_cubit.dart';
import 'package:graduation_project_frontend/screens/forget_password.dart';
import 'package:graduation_project_frontend/screens/signup_page.dart';
import 'package:graduation_project_frontend/widgets/customTextStyle.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';
import 'package:graduation_project_frontend/widgets/mainScaffold.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:graduation_project_frontend/cubit/login_state.dart';
class SigninPage extends StatefulWidget {
  static String id = 'SigninPage';

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadEmail();
    });
  }
  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_email', email);
  }

  Future<void> loadEmail() async {

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('saved_email') ?? '';
    if (savedEmail.isNotEmpty) {
      setState(() {
        isChecked = true;
        BlocProvider.of<LoginCubit>(context).emailController.text = savedEmail;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
         
          if (!mounted) return;
          if (state is LoginSuccess) { 
          context.read<LoginCubit>().connectToSocket(context.read<CenterCubit>().state);
            showAdvancedNotification(
            context,
            message: "Welcome to Radintal as ${state.role}" ,
           type: NotificationType.success,
        style: AnimationStyle.card,
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                // ChatScreen(userId: context.read<CenterCubit>().state,userType: state.role),
                 MainScaffold(role: state.role),
              ),
            );
            
          } else if (state is LoginError) {
            showAdvancedNotification(
        context,
        message: state.message,
        type: NotificationType.error,
        style: AnimationStyle.card,
          );
          }
        },
        builder: (context, state) {
          final loginCubit = BlocProvider.of<LoginCubit>(context);
          return SafeArea(
            child: Row(
              children: [
                if (MediaQuery.of(context).size.width > 600)
                  Expanded(
                    child: Container(
                      color: sky,
                      child: Center(
                        child: Image.asset(
                          "assets/images/Doctor-bro.png",
                          width: 600,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: sky,
                      image: DecorationImage(
                        image: AssetImage("assets/images/image 5.png"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: ListView(
                      children: [
                      SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text("Welcome Back",
                              style: customTextStyle(24, FontWeight.bold, Colors.black)),
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              CustomFormTextField(
                                controller: loginCubit.emailController,
                                hintText: 'Enter your email',
                                validator: (value) =>
                                    value!.contains('@') ? null : 'Invalid email',
                              ),
                              SizedBox(height: 16),
                              CustomFormTextField(
                                obscureText: loginCubit.isLoginPasswordShowing,
                                controller: loginCubit.passwordController,
                                hintText: 'Enter your password',
                                onSubmitted: (value){
                                    loginCubit.login();
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(loginCubit.suffixIcon),
                                  onPressed:
                                      loginCubit.changeLoginPasswordSuffixIcon,
                                ),
                                validator: (value) =>
                                    value!.length >= 6 ? null : 'Password too short',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) =>
                                  setState(() => isChecked = value!),
                            ),
                            GestureDetector(
                              onTap: () => setState(() => isChecked = !isChecked),
                              child: Text("Remember me"),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.pushNamed(context, ForgetPassword.id),
                              child: Text('Forget Password',
                                  style: TextStyle(color: blue)),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        state is LoginLoading
                            ? Center(child: CircularProgressIndicator())
                            : CustomButton(
                                onTap: () async {
                                  if (formKey.currentState!.validate()) {
                                    if (isChecked)
                                      await saveEmail(
                                          loginCubit.emailController.text);
                                    loginCubit.login();
                                  }
                                },
                                text: 'Sign In',
                              ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text('or', style: TextStyle(fontSize: 16)),
                            ),
                            Expanded(child: Divider(color: Colors.grey)),
                          ],
                        ),
                        SizedBox(height: 20),
                        CustomButton(text: "Sign in with Google"),
                        SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () =>
                                    Navigator.pushNamed(context, SignupPage.id),
                                child: Text(' Create One',
                                    style: TextStyle(color: blue)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
