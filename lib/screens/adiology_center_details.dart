// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graduation_project_frontend/cubit/register_cubit.dart';
// import 'package:graduation_project_frontend/cubit/register_state.dart';

// class RadiologyCenterDetails extends StatefulWidget {
//    String userId;
//   RadiologyCenterDetails(this.userId);

//   @override
//   _RadiologyCenterDetailsState createState() => _RadiologyCenterDetailsState();
// }

// class _RadiologyCenterDetailsState extends State<RadiologyCenterDetails> {
//   final TextEditingController centerNameController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();

//   void completeRegistration() {
//     final authCubit = context.read<RegisterCubit>();
//     authCubit.completeRegistration(widget.userId, {
//       "centerName": centerNameController.text,
//       "address": addressController.text,
//       "phoneNumber": phoneController.text,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Radiology Center Details")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: BlocConsumer<RegisterCubit, RegisterState>(
//           listener: (context, state) {
//             if (state is CompleteRegistrationSuccess) {
//               Navigator.pushReplacementNamed(context, "/home");
//             }
//           },
//           builder: (context, state) {
//             if (state is RegisterLoading) {
//               return Center(child: CircularProgressIndicator());
//             }

//             return Column(
//               children: [
//                 TextField(
//                   controller: centerNameController,
//                   decoration: InputDecoration(labelText: "Center Name"),
//                 ),
//                 TextField(
//                   controller: addressController,
//                   decoration: InputDecoration(labelText: "Address"),
//                 ),
//                 TextField(
//                   controller: phoneController,
//                   decoration: InputDecoration(labelText: "Phone Number"),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: completeRegistration,
//                   child: Text("Complete Registration"),
//                 ),
//                 if (state is RegisterFailure) Text(state.error, style: TextStyle(color: Colors.red)),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }



















import 'package:flutter/material.dart';

class SummaryPage extends StatelessWidget {
  final String role;
  final String email;
  //final String address;
  final String contactNumber;
  // final String specialty;
  // final String experience;

  SummaryPage({
    required this.role,
    required this.email,
    //required this.address,
    required this.contactNumber,
    // required this.specialty,
    // required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Summary")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Role: $role", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Email: $email", style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),

            if (role == "Technician") ...[
              //Text("Address: $address", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Contact No: $contactNumber", style: TextStyle(fontSize: 16)),
            ] else if (role == "Doctor") ...[
              // Text("Specialty: $specialty", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              // Text("Years of Experience: $experience", style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("Contact No: $contactNumber", style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }
}
