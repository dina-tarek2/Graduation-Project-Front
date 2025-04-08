
import 'package:graduation_project_frontend/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationSending extends NotificationState {}

class NotificationSent extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
