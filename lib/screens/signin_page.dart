import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  const SigninPage({super.key});

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
     final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;
    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (!mounted) return;
          if (state is LoginSuccess) {
            context
                .read<LoginCubit>()
                .connectToSocket(context.read<CenterCubit>().state);
            showAdvancedNotification(
              context,
              message: "Welcome to Radintal as ${state.role}",
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
                   if (isWideScreen)
        Expanded(
          flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                       
                      
                      image: DecorationImage(
                        image: AssetImage("assets/images/AiDiagnosis.jpg"),
                        fit: BoxFit.cover,
                        // filterQuality: FilterQuality.high,
                        opacity : 2,
                        
                      
                      ),
                    ),
                  child: Stack(
                    children: [
                     
                      Positioned(
                        top: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                         
                          width: 30, 
                          decoration: BoxDecoration(
                            //  color: Colors.white,
                      //         image:DecorationImage(image: 
                      // AssetImage("assets/images/radiologyDoc1.png"),
                      // fit: BoxFit.cover,
                      // ),
                            // gradient: LinearGradient(
                            //   begin: Alignment.centerRight,
                            //   end: Alignment.centerLeft,
                            //   colors: [
                            //     Colors.white,
                            //     Colors.white,
                            //     blue
                            //   ],
                            //   stops: [0.0, 0.25, .5],
                            // ),
                          ),
                        ),
                      ),
                     
                    ],
                  ),
                                    ),
        ),
                Expanded(
                   flex: isWideScreen ? 4 : 10,
                  child: Container(
                     decoration: BoxDecoration(
                   
                       border: Border.all(
        color: blue, 
        width: 2, 
                       ),
                        borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45.0),
                      bottomLeft: Radius.circular(45.0),
                      topLeft: Radius.circular(45.0),
                      bottomRight: Radius.circular(45.0),
                    ),
                    shape: BoxShape.rectangle,
                      color: Colors.white,
                      // boxShadow: isWideScreen ? [
                      //   BoxShadow(
                      //     color: Colors.black12,
                      //     offset: Offset(-2, 0),
                      //     blurRadius: 10,
                      //   )
                      // ] : null,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isWideScreen ? 40 : 20,
                        vertical: 20,
                      ),
                      // image: DecorationImage(
                      //   image: AssetImage("assets/images/image 5.png"),
                      //   fit: BoxFit.fill,
                      // ),
                    // ),
                    child: Container(
                      child: ListView(
                        children: [
                          // if (MediaQuery.of(context).size.width <= 600)
                          //   Padding(
                          //     padding: EdgeInsets.only(top: 60, bottom: 40),
                          //     child: Center(
                          //       child: Image.asset(
                      
                          //         height: 80,
                          //          fit: BoxFit.cover, 
                          //       ),
                          //     ),
                          //   ),
                         SizedBox(height: isWideScreen ? 60 : 20),
                          
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                
                                      //            Image.asset(
                                      // 'assets/images/logo.png', // Replace with your app logo
                                      // width: 80,
                                      // height: 80,                                    ),
                                    Text("Welcome Back",
                                    style: customTextStyle(
                                        24, FontWeight.bold, Colors.black)),
                                        SizedBox(height: 12,),
                                         Row(
                                           mainAxisSize: MainAxisSize.min,
                                           children: [
                                             Text("Don't have an account? ",style:  customTextStyle(
                                        16, FontWeight.w500, Colors.black)),
                                             GestureDetector(
                                               onTap: () =>
                                                   Navigator.pushNamed(context, SignupPage.id),
                                               child: Text(' Create One',
                                                   style: customTextStyle(
                                        16, FontWeight.bold, blue)),
                                             ),
                                           ],
                                         ),
                            ],
                          ),
                              ),
                          Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // SizedBox(height: 20),
                                CustomFormTextField(
                                  controller: loginCubit.emailController,
                                  icon:FontAwesomeIcons.user,
                                  hintText: 'Enter your email',
                                  validator: (value) => value!.contains('@')
                                      ? null
                                      : 'Invalid email',
                                ),
                                SizedBox(height: 16),
                                CustomFormTextField(
                                  obscureText: loginCubit.isLoginPasswordShowing,
                                  controller: loginCubit.passwordController,
                                  hintText: 'Enter your password',
                                  onSubmitted: (value) {
                                    loginCubit.login();
                                  },
                                  //  validator: (value) => value!.contains('@')
                                  //       ? null
                                  //       : 'Invalid email',
                                   icon: FontAwesomeIcons.lock,
                                    suffixIcon: IconButton(
                                      icon: Icon(loginCubit.suffixIcon
                                      ,color: Colors.indigo,),
                                      onPressed: loginCubit.changeLoginPasswordSuffixIcon,
                                    ),
                                  // validator: (value) => value!.length >= 6
                                  //     ? null
                                  //     : 'Password too short',
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
                                onTap: () =>
                                    setState(() => isChecked = !isChecked),
                                child: Text("Remember me"),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                    context, ForgetPassword.id),
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
                          // SizedBox(height: 20),
                          // Row(
                          //   children: [
                          //     Expanded(child: Divider(color: Colors.grey)),
                          //     Padding(
                          //       padding: EdgeInsets.symmetric(horizontal: 8.0),
                          //       child: Text('or', style: TextStyle(fontSize: 16)),
                          //     ),
                          //     Expanded(child: Divider(color: Colors.grey)),
                          //   ],
                          // ),
                          // SizedBox(height: 20),
                          // CustomButton(text: "Sign in with Google"),
                          // SizedBox(height: 20),
                         
                        ],
                      ),
                    ),
                  ),
                ),
            )],
            
            ),
          
          );
        },
      ),
    );
  }
}
class DiagonalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    // نبدأ من أعلى اليمين
    path.moveTo(size.width, 0);
    // نرسم خط مائل إلى أسفل اليسار
    path.lineTo(0, size.height);
    // نذهب للزاوية السفلية اليمنى
    path.lineTo(size.width, size.height);
    // نغلق المسار
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}