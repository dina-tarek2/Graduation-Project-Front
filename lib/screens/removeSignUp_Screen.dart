// import 'package:flutter/material.dart';
// import 'package:graduation_project_frontend/widgets/custom_button.dart';
// import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
// import 'package:graduation_project_frontend/widgets/text_field_widget.dart';
// import 'package:graduation_project_frontend/constants/colors.dart';

// class SignupPage extends StatefulWidget {
//   @override
//   _SignupPageState createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   String? selectedRole; // To store the selected role
//   bool isChecked = false; // To check if the checkbox is selected
  
//   // String? email;
//   // String? password;
//   bool isLoading = false;
//   GlobalKey<FormState> formKey = GlobalKey();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           // Left side (image and logo)
//           Expanded(
//             child: Container(
//               color: sky,
//               child: Center(
//                 child: Image.asset("assets/images/Doctor-bro.png", width: 200),
//               ),
//             ),
//           ),

//           // Right side (form)
//           Expanded(
//             child: SingleChildScrollView(
//               padding: EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Get Started Now",
//                       style:
//                           TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 20),
//                   CustomFormTextField(hintText: "Full Name"),

//                   // Dropdown for Role Selection
//                   Padding(
//                     padding: EdgeInsets.only(bottom: 10),
//                     child: DropdownButtonFormField<String>(
//                       value: selectedRole,
//                       decoration: InputDecoration(
//                         labelText: "Role",
//                         border: OutlineInputBorder(),
//                       ),
//                       items: ["Doctor", "Technician"].map((role) {
//                         return DropdownMenuItem<String>(
//                           value: role,
//                           child: Text(role),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         setState(() {
//                           selectedRole = value;
//                         });
//                       },
//                     ),
//                   ),

//                   CustomFormTextField(hintText: "Email", icon: Icons.email),
//                   CustomFormTextField(hintText: "Password", icon: Icons.lock, obscureText: true),
//                   CustomFormTextField(hintText: "Confirm Password",
//                       icon: Icons.lock, obscureText: true),

//                   // Checkbox for Terms & Conditions
//                   Row(
//                     children: [
//                       Checkbox(
//                         value: isChecked,
//                         onChanged: (bool? value) {
//                           setState(() {
//                             isChecked = value!;
//                           });
//                         },
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             isChecked = !isChecked;
//                           });
//                         },
//                         child: Text("I agree to Terms & Conditions"),
//                       ),
//                     ],
//                   ),

//                   SizedBox(height: 10),

//                   // Sign Up Button
//                   // ElevatedButton(
//                   //   onPressed: () {
//                   //     print("Selected Role: $selectedRole");
//                   //   },
//                   //   style: ElevatedButton.styleFrom(
//                   //     minimumSize: Size(double.infinity, 50),
//                   //   ),
//                   //   child: Text("Sign Up"),
//                   // ),
//                   CustomButton(text:"Sign Up")
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
