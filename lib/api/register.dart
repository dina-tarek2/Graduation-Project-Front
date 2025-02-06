// import 'package:dio/dio.dart';

// class Register{

//   final Dio dio = Dio();

//   Future<void> registerInitial() async {
//     final String url = "https://graduation-project-mmih.vercel.app/api/auth/registerRadiologyCenter";

//     try {
//       Response response = await dio.post(
//         url,
//         data: {
//           "email": emailController.text,
//           "password": passwordController.text,
//         },
//       );

//       if (response.statusCode == 200) {
//         final data = response.data;
//         String role = data["role"];
//         String userId = data["userId"];

//         if (role == "RadiologyCenter") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => RadiologyCenterDetails(userId: userId)),
//           );
//         } else if (role == "Doctor") {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => DoctorDetails(userId: userId)),
//           );
//         }
//       } else {
//         print("Error: ${response.data['message']}");
//       }
//     } catch (error) {
//       print("Network error: $error");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Register")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: "Email"),
//             ),
//             TextField(
//               controller: passwo

// }