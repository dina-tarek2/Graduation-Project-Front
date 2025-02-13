import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/contact_cubit.dart';
import 'package:graduation_project_frontend/widgets/custom_button.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';

class ContactScreen extends StatelessWidget {
    static String id = 'ContactScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Contact Us")),r
        body: Row( 
        children: [  
          Expanded(
                child: Container(
                  color: sky,
                  child: Center(
                    child:
                        Image.asset("assets/images/Mention-bro.png", width: 700),
                  ),
                ),
              ),
     Expanded(
        flex: 2,
        child: Padding(
          padding: const EdgeInsets.all(65),
          child: BlocConsumer<ContactCubit, ContactState>(
            listener: (context, state) {
              if (state is ContactSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              } else if (state is ContactFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
            builder: (context, state) {
            
              return Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text('Contact Us' ,style: TextStyle(
                                      fontSize: 34, fontWeight: FontWeight.bold,
                                    ),),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                children: [
                  Text('You Can reach us anytime via' ,style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.bold
                ),),
                 Text('shahd@gmail.com' ,style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.normal,
                  color: Colors.blueAccent
                ),),
                ],  
                ),
              ),
               const SizedBox(
                              height: 20,
                            ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment:CrossAxisAlignment.start,
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
                    SizedBox(height: 20),
                   ( state is ContactLoading)
                        ? CircularProgressIndicator()
                        : CustomButton(
                            onTap: () {
                              BlocProvider.of<ContactCubit>(context).contact();
                            },
                           text: "Get Started",
                          ),
                 
                      ],  
                    ),
                    ],
              );  
                },  
              ),  
            ),  
          ),  
        ],  
      ),  
    );  
  }  
}  
