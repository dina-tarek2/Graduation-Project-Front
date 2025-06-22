import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:bloc/bloc.dart';
part 'setting_state.dart';

class SettingCubit extends Cubit<SettingState> {
  SettingCubit(
    this.api,
  ) : super(SettingInitial());
  ApiConsumer api;
}
