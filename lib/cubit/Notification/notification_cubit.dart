import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/models/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.api) : super(NotificationInitial());
  final ApiConsumer api;
  List<AppNotification> notifications = [];

  Future<int> loadNotifications(String userId) async {
    emit(NotificationLoading());

    try {
      final response = await api.get(
        'https://graduation-project--xohomg.fly.dev/api/notifications/all/$userId',
      );

      final responseData = response.data;
      print('Response data: $responseData'); // طباعة استجابة الإشعار المرسلrr
      if (responseData != null &&
          responseData['success'] == true &&
          responseData['notifications'] != null) {
        final List<dynamic> data = responseData['notifications'];

        final List<AppNotification> loaded =
            data.map((notif) => AppNotification.fromJson(notif)).toList();


        notifications = loaded;
        emit(NotificationLoaded(loaded));
        //unread notification
        int unread = 0;
        for (int i = 0; i < notifications.length; i++) {
          if (notifications[i].isRead == false) {
            unread++;
          }
        }
        return unread;
      } else {
        emit(
            NotificationError('فشل في تحميل الإشعارات أو البيانات غير مكتملة'));
        return 0;
      }
    } catch (e) {
      emit(NotificationError('❌Error loading notifications: $e'));
      print('❌Error loading notifications: $e');
      return 0;
    }
  }

  Future<void> sendNotification(
      String userId, String userType, String title, String message) async {
    emit(NotificationSending());

    try {
      final response = await api.post(
        'http://graduation-project-mmih.vercel.app/api/notifications/send',
        data: {
          'userId': userId,
          'userType': userType,
          'title': title,
          'message': message,
        },
      );

      print(
          '✅Response Notification Sent: ${response}'); // طباعة استجابة الإشعار المرسل

      if (response['status'] == true) {
        emit(NotificationSent());
      } else {
        emit(NotificationError('فشل في إرسال الإشعار'));
      }
    } catch (e) {
      emit(NotificationError('خطأ: $e'));
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final response = await api.put(
        'https://graduation-project-mmih.vercel.app/api/notifications/read/$notificationId',
      );

      if (response['status'] == true) {
        print('the notification has been marked as read');
      } else {
        print('Failed to mark notification as read');
      }
    } catch (e) {
      print('❌error: $e');
    }
  }

  void markAsRead(int index) async {
    final notificationId = notifications[index].id;
    await markNotificationAsRead(notificationId);

    // إنشاء نسخة جديدة من الإشعار مع التحديث
    final updatedNotification = notifications[index].copyWith(isRead: true);

    // تحديث القائمة بالإشعار المعدل
    notifications[index] = updatedNotification;

    emit(NotificationLoaded(List.from(notifications)));
  }
}
