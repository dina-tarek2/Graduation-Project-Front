part of 'setting_cubit.dart';

sealed class SettingState {}

final class SettingInitial extends SettingState {}

class SettingLoading extends SettingState {}

class SettingLoaded extends SettingState {}

class SettingUpdated extends SettingState {
}

class SettingError extends SettingState {
}
