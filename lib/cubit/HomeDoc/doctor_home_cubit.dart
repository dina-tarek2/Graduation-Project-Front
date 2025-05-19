import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'doctor_home_state.dart';

class DoctorHomeCubit extends Cubit<DoctorHomeState> {
  DoctorHomeCubit() : super(DoctorHomeInitial());
}
