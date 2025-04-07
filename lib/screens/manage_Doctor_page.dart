
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/dio_consumer.dart';
import 'package:graduation_project_frontend/constants/colors.dart';
import 'package:graduation_project_frontend/cubit/doctor/doctor_cubit.dart';
import 'package:graduation_project_frontend/widgets/custom_text_field.dart';
@immutable
class ManageDoctorsPage extends StatefulWidget {
  String centerId ;
  ManageDoctorsPage({super.key, required this.centerId});

  @override
  State<ManageDoctorsPage> createState() => _ManageDoctorsPageState();
}

class _ManageDoctorsPageState extends State<ManageDoctorsPage> {
  TextEditingController idRadiologist = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          DoctorCubit(DioConsumer(dio: Dio()))..fetchDoctors(widget.centerId),
      child: Scaffold(
        body: BlocBuilder<DoctorCubit, DoctorListState>(
          builder: (context, state) {
            if (state is DoctorListLoading) {
              return Center(
                child: CircularProgressIndicator(
                  // color: Theme.of(context).primaryColor,
                ),
              );
            } else if (state is DoctorListSuccess) {
              final doctors = state.doctors;
              return doctors.isEmpty
                  ? _buildEmptyState(context)
                  : _buildDoctorsList(context, doctors);
            } else if (state is DoctorListError) {
              return _buildErrorState(context, state.error);
            }
            return _buildEmptyState(context);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              
                context: context,
                builder: (context) {
                   return BlocProvider.value(
          value: context.read<DoctorCubit>(),
                  child:  AlertDialog(
                    shape : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
                    title: Text('Add Doctor'),
                    content: CustomFormTextField(
                      controller: idRadiologist,
                      hintText: 'Enter Doctor Id',
                    ),
                    actions: [
                      TextButton(onPressed: () {
                        Navigator.of(context).pop();},
                       child: Text("Cancel",style: TextStyle(color: Colors.redAccent),)),
                      TextButton(
                          onPressed: ()async {
                              final doctorsCubit =context.read<DoctorCubit>();
                          
                              await doctorsCubit.AddDoctor(idRadiologist.text, widget.centerId);
                               doctorsCubit.emit(DoctorListLoading());
                               await  doctorsCubit.fetchDoctors(widget.centerId);
                                setState(() {});
                            Navigator.of(context).pop();
                              idRadiologist.clear();
                             
                            
                          },
                          child: Text('Ok',style: TextStyle(color: darkBlue),))
                    ],
                  )
                  );
                });
          },
          tooltip: "Add New Doctor",
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDoctorsList(BuildContext context, List<dynamic> doctors) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Medical Team",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "${doctors.length} doctors available",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: doctors.length,
              separatorBuilder: (context, index) => SizedBox(height: 12),
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return DoctorCard(doctor: doctor,index: index,);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            "No doctors found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add doctors to your medical center",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                   return BlocProvider.value(
          value: context.read<DoctorCubit>(),
                  child:  AlertDialog(
                    title: Text('Add Doctor'),
                    content: CustomFormTextField(
                      controller: idRadiologist,
                      hintText: 'Enter Id For Radiologist You Want Add him',
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            final doctorsCubit = context.read<DoctorCubit>();
                          
                                doctorsCubit.AddDoctor(idRadiologist.text, widget.centerId);
                         
                             doctorsCubit.fetchDoctors(widget.centerId);
                                Navigator.of(context).pop();
                                idRadiologist.clear();
                          },
                          child: Text('Ok'))
                    ],
                  )
                  );
                });
            },
            icon: Icon(Icons.add),
            label: Text("Add Doctor"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red[300],
          ),
          SizedBox(height: 16),
          Text(
            "Something went wrong",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              BlocProvider.of<DoctorCubit>(context).fetchDoctors(widget.centerId);
            },
            icon: Icon(Icons.refresh),
            label: Text("Try Again"),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final dynamic doctor;
  final int index;
  const DoctorCard({super.key, required this.doctor, required this.index});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              child: Text(
                "${doctor.firstName[0]}${doctor.lastName[0]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  // color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dr. ${doctor.firstName} ${doctor.lastName}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      // color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      doctor.specialization.join(", "),
                      style: TextStyle(
                        fontSize: 12,
                        // color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                       context
                                .read<DoctorCubit>()
                                .deleteDoctors(index);
                  },
                  tooltip: "Delete",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
