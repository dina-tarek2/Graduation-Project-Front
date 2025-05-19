import 'package:graduation_project_frontend/models/notification_model.dart';

abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int unreadNotifications;
  final int totalNotifications;
  NotificationLoaded(this.notifications,
      {this.unreadNotifications = 0, this.totalNotifications = 0});
}

class Notificationload extends NotificationState {
  final AppNotification notification;
  Notificationload(this.notification);
}

class NotificationSending extends NotificationState {}

class NotificationSent extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);
}
