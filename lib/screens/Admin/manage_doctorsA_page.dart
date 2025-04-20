// import 'package:flutter/material.dart';

// class ManageDoctorsaPage extends StatefulWidget {
//   const ManageDoctorsaPage({super.key});

//   @override
//   State<ManageDoctorsaPage> createState() => _ManageDoctorsaPageState();
// }

// class _ManageDoctorsaPageState extends State<ManageDoctorsaPage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// import 'package:flutter/material.dart';

// class Doctor {
//   final String name;
//   final String specialty;
//   final String id;
//   final String email;
//   final String phoneNumber;
//   final String dateAdded;
//   final String timeAdded;
//   final bool isApproved;
//   final String avatarAsset;

//   Doctor({
//     required this.name,
//     required this.specialty,
//     required this.id,
//     required this.email,
//     required this.phoneNumber,
//     required this.dateAdded,
//     required this.timeAdded,
//     required this.isApproved,
//     required this.avatarAsset,
//   });
// }

// class ManageDoctorsaPage extends StatefulWidget {
//   const ManageDoctorsaPage({Key? key}) : super(key: key);

//   @override
//   State<ManageDoctorsaPage> createState() => _ManageDoctorsaPageState();
// }

// class _ManageDoctorsaPageState extends State<ManageDoctorsaPage> {
//   final List<Doctor> doctors = [
//     Doctor(
//       name: 'Brooklyn Simmons',
//       specialty: 'Dermatologists',
//       id: '87364523',
//       email: 'brooklyns@mail.com',
//       phoneNumber: '(603) 555-0123',
//       dateAdded: '21/12/2022',
//       timeAdded: '10:40 PM',
//       isApproved: true,
//       avatarAsset: 'assets/doctor1.png',
//     ),
//     Doctor(
//       name: 'Kristin Watson',
//       specialty: 'Infectious disease',
//       id: '93874563',
//       email: 'kristinw@mail.com',
//       phoneNumber: '(219) 555-0114',
//       dateAdded: '22/12/2022',
//       timeAdded: '05:20 PM',
//       isApproved: false,
//       avatarAsset: 'assets/doctor2.png',
//     ),
//     Doctor(
//       name: 'Jacob Jones',
//       specialty: 'Ophthalmologists',
//       id: '23847569',
//       email: 'jacobj@mail.com',
//       phoneNumber: '(319) 555-0115',
//       dateAdded: '23/12/2022',
//       timeAdded: '12:40 PM',
//       isApproved: true,
//       avatarAsset: 'assets/doctor3.png',
//     ),
//     Doctor(
//       name: 'Cody Fisher',
//       specialty: 'Cardiologists',
//       id: '39485632',
//       email: 'codyf@mail.com',
//       phoneNumber: '(229) 555-0109',
//       dateAdded: '24/12/2022',
//       timeAdded: '03:00 PM',
//       isApproved: true,
//       avatarAsset: 'assets/doctor4.png',
//     ),
//     Doctor(
//       name: 'Brooklyn Simmons',
//       specialty: 'Dermatologists',
//       id: '87364523',
//       email: 'brooklyns@mail.com',
//       phoneNumber: '(603) 555-0123',
//       dateAdded: '21/12/2022',
//       timeAdded: '10:40 PM',
//       isApproved: true,
//       avatarAsset: 'assets/doctor1.png',
//     ),
//     Doctor(
//       name: 'Kristin Watson',
//       specialty: 'Infectious disease',
//       id: '93874563',
//       email: 'kristinw@mail.com',
//       phoneNumber: '(219) 555-0114',
//       dateAdded: '22/12/2022',
//       timeAdded: '05:20 PM',
//       isApproved: false,
//       avatarAsset: 'assets/doctor2.png',
//     ),
//     Doctor(
//       name: 'Jacob Jones',
//       specialty: 'Ophthalmologists',
//       id: '23847569',
//       email: 'jacobj@mail.com',
//       phoneNumber: '(319) 555-0115',
//       dateAdded: '23/12/2022',
//       timeAdded: '12:40 PM',
//       isApproved: true,
//       avatarAsset: 'assets/doctor3.png',
//     ),
//     Doctor(
//       name: 'Cody Fisher',
//       specialty: 'Cardiologists',
//       id: '39485632',
//       email: 'codyf@mail.com',
//       phoneNumber: '(229) 555-0109',
//       dateAdded: '24/12/2022',
//       timeAdded: '03:00 PM',
//       isApproved: true,
//       avatarAsset: 'assets/doctor4.png',
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeader(),
//             const SizedBox(height: 24),
//             _buildTableHeader(),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: doctors.length,
//                 itemBuilder: (context, index) {
//                   return _buildDoctorRow(doctors[index]);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'List of doctors',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               '348 available doctors',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ],
//         ),
//         ElevatedButton.icon(
//           onPressed: () {},
//           icon: const Icon(Icons.add),
//           label: const Text('Add new doctor'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF6B9E76),
//             foregroundColor: Colors.white,
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTableHeader() {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           const SizedBox(width: 40),
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Name',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               'ID',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Email',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Phone number',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               'Date added',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               'STATUS',
//               style: TextStyle(
//                 fontSize: 14,
//                 fontWeight: FontWeight.w500,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//           const SizedBox(width: 40),
//         ],
//       ),
//     );
//   }

//   Widget _buildDoctorRow(Doctor doctor) {
//     return Container(
//       margin: const EdgeInsets.only(top: 2),
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 20,
//             backgroundColor: Colors.blue.shade50,
//             backgroundImage: AssetImage(doctor.avatarAsset),
//           ),
//           Expanded(
//             flex: 2,
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     doctor.name,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     doctor.specialty,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Text(
//               doctor.id,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               doctor.email,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Text(
//               doctor.phoneNumber,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//           Expanded(
//             flex: 2,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   doctor.dateAdded,
//                   style: const TextStyle(fontSize: 14),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   doctor.timeAdded,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               decoration: BoxDecoration(
//                 color: doctor.isApproved
//                     ? const Color(0xFFEAF5EB)
//                     : const Color(0xFFFFE8E8),
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: Text(
//                 doctor.isApproved ? 'Approved' : 'Declined',
//                 style: TextStyle(
//                   fontSize: 12,
//                   color: doctor.isApproved
//                       ? const Color(0xFF6B9E76)
//                       : const Color(0xFFFF5D5D),
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.chevron_right, color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }

//caludii 222222

import 'package:flutter/material.dart';

class Doctor {
  final String name;
  final String specialty;
  final String id;
  final String email;
  final String phoneNumber;
  final String dateAdded;
  final String timeAdded;
  final bool isApproved;
  final String avatarAsset;

  Doctor({
    required this.name,
    required this.specialty,
    required this.id,
    required this.email,
    required this.phoneNumber,
    required this.dateAdded,
    required this.timeAdded,
    required this.isApproved,
    required this.avatarAsset,
  });
}

class ManageDoctorsaPage extends StatefulWidget {
  const ManageDoctorsaPage({Key? key}) : super(key: key);

  @override
  State<ManageDoctorsaPage> createState() => _ManageDoctorsaPageState();
}

class _ManageDoctorsaPageState extends State<ManageDoctorsaPage> {
  final List<Doctor> doctors = [
    Doctor(
      name: 'Brooklyn Simmons',
      specialty: 'Dermatologists',
      id: '87364523',
      email: 'brooklyns@mail.com',
      phoneNumber: '(603) 555-0123',
      dateAdded: '21/12/2022',
      timeAdded: '10:40 PM',
      isApproved: true,
      avatarAsset: 'assets/doctor1.png',
    ),
    Doctor(
      name: 'Kristin Watson',
      specialty: 'Infectious disease',
      id: '93874563',
      email: 'kristinw@mail.com',
      phoneNumber: '(219) 555-0114',
      dateAdded: '22/12/2022',
      timeAdded: '05:20 PM',
      isApproved: false,
      avatarAsset: 'assets/doctor2.png',
    ),
    Doctor(
      name: 'Jacob Jones',
      specialty: 'Ophthalmologists',
      id: '23847569',
      email: 'jacobj@mail.com',
      phoneNumber: '(319) 555-0115',
      dateAdded: '23/12/2022',
      timeAdded: '12:40 PM',
      isApproved: true,
      avatarAsset: 'assets/doctor3.png',
    ),
    Doctor(
      name: 'Cody Fisher',
      specialty: 'Cardiologists',
      id: '39485632',
      email: 'codyf@mail.com',
      phoneNumber: '(229) 555-0109',
      dateAdded: '24/12/2022',
      timeAdded: '03:00 PM',
      isApproved: true,
      avatarAsset: 'assets/doctor4.png',
    ),
    Doctor(
      name: 'Brooklyn Simmons',
      specialty: 'Dermatologists',
      id: '87364523',
      email: 'brooklyns@mail.com',
      phoneNumber: '(603) 555-0123',
      dateAdded: '21/12/2022',
      timeAdded: '10:40 PM',
      isApproved: true,
      avatarAsset: 'assets/doctor1.png',
    ),
    Doctor(
      name: 'Kristin Watson',
      specialty: 'Infectious disease',
      id: '93874563',
      email: 'kristinw@mail.com',
      phoneNumber: '(219) 555-0114',
      dateAdded: '22/12/2022',
      timeAdded: '05:20 PM',
      isApproved: false,
      avatarAsset: 'assets/doctor2.png',
    ),
    Doctor(
      name: 'Jacob Jones',
      specialty: 'Ophthalmologists',
      id: '23847569',
      email: 'jacobj@mail.com',
      phoneNumber: '(319) 555-0115',
      dateAdded: '23/12/2022',
      timeAdded: '12:40 PM',
      isApproved: true,
      avatarAsset: 'assets/doctor3.png',
    ),
    Doctor(
      name: 'Cody Fisher',
      specialty: 'Cardiologists',
      id: '39485632',
      email: 'codyf@mail.com',
      phoneNumber: '(229) 555-0109',
      dateAdded: '24/12/2022',
      timeAdded: '03:00 PM',
      isApproved: true,
      avatarAsset: 'assets/doctor4.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildTableHeader(),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  return _buildDoctorRow(doctors[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'List of doctors',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '348 available doctors',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add new doctor'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6B9E76),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100, // رمادي خفيف للخلفية
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 40),
          Expanded(
            flex: 2,
            child: Text(
              'Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'ID',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Phone number',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date added',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              'STATUS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildDoctorRow(Doctor doctor) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue.shade50,
            backgroundImage: AssetImage(doctor.avatarAsset),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    doctor.specialty,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              doctor.id,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              doctor.email,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              doctor.phoneNumber,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.dateAdded,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.timeAdded,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: doctor.isApproved
                    ? const Color(0xFFEAF5EB)
                    : const Color(0xFFFFE8E8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                doctor.isApproved ? 'Approved' : 'Declined',
                style: TextStyle(
                  fontSize: 12,
                  color: doctor.isApproved
                      ? const Color(0xFF6B9E76)
                      : const Color(0xFFFF5D5D),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.chevron_right, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
