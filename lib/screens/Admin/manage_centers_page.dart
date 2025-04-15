import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/cubit/Admin/manage_centers_cubit.dart';

class ManageCentersPage extends StatefulWidget {
 

  @override
  State<ManageCentersPage> createState() => _ManageCentersPageState();
}

class _ManageCentersPageState extends State<ManageCentersPage> {
  
  @override
  void initState() {
    super.initState();
    context.read<ManageCentersCubit>().fetchApprovedCenters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<ManageCentersCubit, ManageCentersState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is ManageCentersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is ManageCentersFailure) {
            return Center(
              child: Text("Error is : ${state.error}"),
            );
          } else if (state is ManageCentersSuccess) {
            return Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      // Search Bar
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Color(0xFF64748B)),
                              SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search Radiology Centers',
                                    border: InputBorder.none,
                                    hintStyle:
                                        TextStyle(color: Color(0xFF94A3B8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 20),

                      // Send Request Button
                      ElevatedButton.icon(
                        icon: Icon(Icons.add, size: 16),
                        label: Text('Add Center'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0EA5E9),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),

                // Content Area
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'All Radiology Centers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Centers Grid
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            childAspectRatio: 2.5,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                            children: [
                              _buildChemistCard(
                                  'Maria Jane',
                                  // state.centers.
                                  'Hi, I\'m Maria Jane. Lorem ipsum is simply dummy text for printing and typesetting.',
                                  '43 Task',
                                  '4.7'),
                              _buildChemistCard(
                                  'Alex Stanton',
                                  'Hi, I\'m Alex Stanton. Lorem ipsum is simply dummy text for printing and typesetting.',
                                  '49 Task',
                                  '4.9'),
                              _buildChemistCard(
                                  'Alina White',
                                  'Hi, I\'m Alina White. Lorem ipsum is simply dummy text for printing and typesetting.',
                                  '63 Task',
                                  '4.8'),
                              _buildChemistCard(
                                  'Richard Kyle',
                                  'Hi, I\'m Richard Kyle. Lorem ipsum is simply dummy text for printing and typesetting.',
                                  '40 Task',
                                  '4.7'),
                              _buildChemistCard(
                                  'Andrew Grossman',
                                  'Hi, I\'m Andrew Grossman. Lorem ipsum is simply dummy text of the printing and.',
                                  '59 Projects',
                                  '4.8'),
                              _buildChemistCard(
                                  'Jade Phillips',
                                  'Hi, I\'m Jade Phillips. Lorem ipsum is simply dummy text of the printing and.',
                                  '45 Task',
                                  '4.9'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Text("no state ui");
          }
        },
      ),
    );
  }

  Widget _buildChemistCard(
      String name, String bio, String tasks, String rating) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0xFFE2E8F0),
                    radius: 20,
                    child: Icon(Icons.person, color: Color(0xFF94A3B8)),
                  ),
                  SizedBox(width: 12),
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Chat',
                  style: TextStyle(
                    color: Color(0xFF0EA5E9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            bio,
            style: TextStyle(
              color: Color(0xFF64748B),
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                tasks,
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                ),
              ),
              Row(
                children: [
                  Text(
                    rating,
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.star,
                    color: Color(0xFFF59E0B),
                    size: 14,
                  ),
                  SizedBox(width: 2),
                  Text(
                    'Reviews',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}




//cauldi with pagination
// import 'package:flutter/material.dart';

// class ManageCentersPage extends StatefulWidget {
//   @override
//   _ManageCentersPageState createState() => _ManageCentersPageState();
// }

// class _ManageCentersPageState extends State<ManageCentersPage> {
//   int currentPage = 1;
//   int totalPages = 3;
 
//   // List of chemists data for different pages
//   final List<List<Map<String, String>>> pagesData = [
//     // Page 1
//     [
//       {
//         'name': 'Maria Jane',
//         'bio':
//             'Hi, I\'m Maria Jane. Lorem ipsum is simply dummy text for printing and typesetting.',
//         'tasks': '43 Task',
//         'rating': '4.7'
//       },
//       {
//         'name': 'Alex Stanton',
//         'bio':
//             'Hi, I\'m Alex Stanton. Lorem ipsum is simply dummy text for printing and typesetting.',
//         'tasks': '49 Task',
//         'rating': '4.9'
//       },
//       {
//         'name': 'Alina White',
//         'bio':
//             'Hi, I\'m Alina White. Lorem ipsum is simply dummy text for printing and typesetting.',
//         'tasks': '63 Task',
//         'rating': '4.8'
//       },
//       {
//         'name': 'Richard Kyle',
//         'bio':
//             'Hi, I\'m Richard Kyle. Lorem ipsum is simply dummy text for printing and typesetting.',
//         'tasks': '40 Task',
//         'rating': '4.7'
//       },
//       {
//         'name': 'Andrew Grossman',
//         'bio':
//             'Hi, I\'m Andrew Grossman. Lorem ipsum is simply dummy text of the printing and.',
//         'tasks': '59 Projects',
//         'rating': '4.8'
//       },
//       {
//         'name': 'Jade Phillips',
//         'bio':
//             'Hi, I\'m Jade Phillips. Lorem ipsum is simply dummy text of the printing and.',
//         'tasks': '45 Task',
//         'rating': '4.9'
//       },
//     ],
//     // Page 2
//     // [
//     //   {
//     //     'name': 'Emily Johnson',
//     //     'bio':
//     //         'Hi, I\'m Emily Johnson. Specialized in organic chemistry and molecular analysis.',
//     //     'tasks': '38 Task',
//     //     'rating': '4.6'
//     //   },
//     //   {
//     //     'name': 'David Chen',
//     //     'bio':
//     //         'Hi, I\'m David Chen. Expert in biochemical research and laboratory testing.',
//     //     'tasks': '51 Task',
//     //     'rating': '4.8'
//     //   },
//     //   {
//     //     'name': 'Sophie Martin',
//     //     'bio':
//     //         'Hi, I\'m Sophie Martin. Focused on pharmaceutical chemistry and drug development.',
//     //     'tasks': '47 Task',
//     //     'rating': '4.9'
//     //   },
//     //   {
//     //     'name': 'Michael Brown',
//     //     'bio':
//     //         'Hi, I\'m Michael Brown. Specializing in analytical chemistry and spectroscopy.',
//     //     'tasks': '42 Task',
//     //     'rating': '4.5'
//     //   },
//     //   {
//     //     'name': 'Lisa Taylor',
//     //     'bio':
//     //         'Hi, I\'m Lisa Taylor. Working on environmental chemistry and sustainability.',
//     //     'tasks': '36 Projects',
//     //     'rating': '4.7'
//     //   },
//     //   {
//     //     'name': 'Kevin Rodriguez',
//     //     'bio':
//     //         'Hi, I\'m Kevin Rodriguez. Expert in inorganic chemistry and catalysis research.',
//     //     'tasks': '44 Task',
//     //     'rating': '4.8'
//     //   },
//     // ],
//     // Page 3
//     // [
//     //   {
//     //     'name': 'Sarah Wilson',
//     //     'bio':
//     //         'Hi, I\'m Sarah Wilson. Specialized in polymer chemistry and materials science.',
//     //     'tasks': '39 Task',
//     //     'rating': '4.7'
//     //   },
//     //   {
//     //     'name': 'James Lee',
//     //     'bio':
//     //         'Hi, I\'m James Lee. Researcher in computational chemistry and molecular modeling.',
//     //     'tasks': '53 Task',
//     //     'rating': '4.9'
//     //   },
//     //   {
//     //     'name': 'Natalie Clark',
//     //     'bio':
//     //         'Hi, I\'m Natalie Clark. Expert in food chemistry and nutritional analysis.',
//     //     'tasks': '46 Task',
//     //     'rating': '4.8'
//     //   },
//     //   {
//     //     'name': 'Robert Harris',
//     //     'bio':
//     //         'Hi, I\'m Robert Harris. Specializing in medicinal chemistry and drug discovery.',
//     //     'tasks': '50 Task',
//     //     'rating': '4.9'
//     //   },
//     //   {
//     //     'name': 'Emma Scott',
//     //     'bio':
//     //         'Hi, I\'m Emma Scott. Working on nanomaterials and green chemistry applications.',
//     //     'tasks': '41 Projects',
//     //     'rating': '4.6'
//     //   },
//     //   {
//     //     'name': 'Daniel Morgan',
//     //     'bio':
//     //         'Hi, I\'m Daniel Morgan. Expert in analytical techniques for chemical identification.',
//     //     'tasks': '48 Task',
//     //     'rating': '4.7'
//     //   },
//     // ],
//   ];

//   void changePage(int page) {
//     setState(() {
//       currentPage = page;
      
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Get current page data (index starts from 0)
//     List<Map<String, String>> currentChemists = pagesData[currentPage - 1];

//     return Scaffold(
//       body: Column(
//         children: [
//           // Top Bar
//           Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Row(
//               children: [
//                 // Search Bar
//                 Expanded(
//                   child: Container(
//                     height: 40,
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     decoration: BoxDecoration(
//                       color: Color(0xFFF1F5F9),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(Icons.search, color: Color(0xFF64748B)),
//                         SizedBox(width: 10),
//                         Expanded(
//                           child: TextField(
//                             decoration: InputDecoration(
//                               hintText: 'Search Chemists',
//                               border: InputBorder.none,
//                               hintStyle: TextStyle(color: Color(0xFF94A3B8)),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 SizedBox(width: 20),

//                 // Send Request Button
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.add, size: 16),
//                   label: Text('Send Request'),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF0EA5E9),
//                     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ),

//           // Content Area
//           Expanded(
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'All Chemists',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   SizedBox(height: 20),

//                   // Chemists Grid - Dynamic based on current page
//                   Expanded(
//                     child: GridView.builder(
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 2,
//                         childAspectRatio: 2.5,
//                         crossAxisSpacing: 20,
//                         mainAxisSpacing: 20,
//                       ),
//                       itemCount: currentChemists.length,
//                       itemBuilder: (context, index) {
//                         final chemist = currentChemists[index];
//                         return _buildChemistCard(
//                             chemist['name']!,
//                             chemist['bio']!,
//                             chemist['tasks']!,
//                             chemist['rating']!);
//                       },
//                     ),
//                   ),

//                   // Pagination
//                   Container(
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.symmetric(vertical: 20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Previous page button
//                         IconButton(
//                           icon: Icon(Icons.chevron_left),
//                           onPressed: currentPage > 1
//                               ? () => changePage(currentPage - 1)
//                               : null,
//                           color: Color(0xFF0EA5E9),
//                         ),

//                         // Page numbers
//                         for (int i = 1; i <= totalPages; i++)
//                           _buildPageButton(i),

//                         // Next page button
//                         IconButton(
//                           icon: Icon(Icons.chevron_right),
//                           onPressed: currentPage < totalPages
//                               ? () => changePage(currentPage + 1)
//                               : null,
//                           color: Color(0xFF0EA5E9),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPageButton(int pageNumber) {
//     bool isCurrentPage = pageNumber == currentPage;

//     return InkWell(
//       onTap: () =>changePage(pageNumber),
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 5),
//         width: 32,
//         height: 32,
//         decoration: BoxDecoration(
//           color: isCurrentPage ? Color(0xFF0EA5E9) : Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           border: Border.all(
//             color: isCurrentPage ? Color(0xFF0EA5E9) : Color(0xFFCBD5E1),
//             width: 1,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             '$pageNumber',
//             style: TextStyle(
//               color: isCurrentPage ? Colors.white : Color(0xFF64748B),
//               fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildChemistCard(
//       String name, String bio, String tasks, String rating) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       padding: EdgeInsets.all(15),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     backgroundColor: Color(0xFFE2E8F0),
//                     radius: 20,
//                     child: Icon(Icons.person, color: Color(0xFF94A3B8)),
//                   ),
//                   SizedBox(width: 12),
//                   Text(
//                     name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ],
//               ),
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: Color(0xFFE0F2FE),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   'Chat',
//                   style: TextStyle(
//                     color: Color(0xFF0EA5E9),
//                     fontSize: 12,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 10),
//           Text(
//             bio,
//             style: TextStyle(
//               color: Color(0xFF64748B),
//               fontSize: 12,
//             ),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Spacer(),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 tasks,
//                 style: TextStyle(
//                   color: Color(0xFF64748B),
//                   fontSize: 12,
//                 ),
//               ),
//               Row(
//                 children: [
//                   Text(
//                     rating,
//                     style: TextStyle(
//                       color: Color(0xFF64748B),
//                       fontSize: 12,
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Icon(
//                     Icons.star,
//                     color: Color(0xFFF59E0B),
//                     size: 14,
//                   ),
//                   SizedBox(width: 2),
//                   Text(
//                     'Reviews',
//                     style: TextStyle(
//                       color: Color(0xFF64748B),
//                       fontSize: 12,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
