import 'package:equatable/equatable.dart';
import 'package:graduation_project_frontend/models/centerDashboard_model.dart';

abstract class DashboardState extends Equatable {
  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {
  final double loadProgress;
  
  DashboardLoading(this.loadProgress);
  
  @override
  List<Object> get props => [loadProgress];
}

class DashboardLoaded extends DashboardState {
  final Centerdashboard data;
  
  DashboardLoaded(this.data);
  
  @override
  List<Object> get props => [data];
}

class DashboardError extends DashboardState {
  final String message;
  
  DashboardError(this.message);
  
  @override
  List<Object> get props => [message];
}
