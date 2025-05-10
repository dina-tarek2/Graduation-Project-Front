import 'package:flutter/material.dart' hide AnimationStyle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/contact_cubit.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
import 'package:graduation_project_frontend/widgets/custom_toast.dart';

class ContactScreen extends StatelessWidget {
  static String id = 'ContactScreen';
  final String role;

  const ContactScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            color: sky,
            child: Center(
              child: Image.asset("assets/images/Mention-bro.png",
                  width: MediaQuery.of(context).size.width * 0.4),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
              child: BlocConsumer<ContactCubit, ContactState>(
                listener: (context, state) {
                  if (state is ContactSuccess) {
                    showAdvancedNotification(
                      context,
                      message: "The Massage Sent Successfuly",
                      type: NotificationType.success,
                      style: AnimationStyle.card,
                    );

                    BlocProvider.of<ContactCubit>(context)
                        .emailController
                        .clear();
                    BlocProvider.of<ContactCubit>(context)
                        .nameController
                        .clear();
                    BlocProvider.of<ContactCubit>(context)
                        .phoneController
                        .clear();
                    BlocProvider.of<ContactCubit>(context)
                        .messageController
                        .clear();
                  } else if (state is ContactFailure) {
                    showAdvancedNotification(
                      context,
                      message: "Failed to send the message: ${state.error}",
                      type: NotificationType.error,
                      style: AnimationStyle.card,
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Row(
                          children: [
                            Text(
                              'You Can reach us anytime via',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.02,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 2),
                            Text(
                              'shahd@gmail.com',
                              style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.01,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomFormTextField(
                                controller:
                                    BlocProvider.of<ContactCubit>(context)
                                        .nameController,
                                hintText: 'Enter your name',
                                labelText: 'Name',
                              ),
                              CustomFormTextField(
                                  controller:
                                      BlocProvider.of<ContactCubit>(context)
                                          .emailController,
                                  hintText: 'Enter your email',
                                  labelText: 'Email',
                                  icon: Icons.email),
                              CustomFormTextField(
                                  controller:
                                      BlocProvider.of<ContactCubit>(context)
                                          .phoneController,
                                  hintText: 'Enter your phone number',
                                  labelText: 'Phone',
                                  icon: Icons.phone),
                              CustomFormTextField(
                                  controller:
                                      BlocProvider.of<ContactCubit>(context)
                                          .messageController,
                                  hintText: 'Enter your massage',
                                  labelText: 'How Can We Help You',
                                  maxLines: 5,
                                  icon: Icons.sms),
                              SizedBox(height: 5),
                              (state is ContactLoading)
                                  ? CircularProgressIndicator()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CustomButton(
                                        onTap: () {
                                          BlocProvider.of<ContactCubit>(context)
                                              .contact();
                                        },
                                        text: "Get Started",
                                        width:
                                            MediaQuery.of(context).size.height *
                                                0.8,
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
