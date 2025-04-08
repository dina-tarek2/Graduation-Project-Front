import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graduation_project_frontend/api_services/api_consumer.dart';
import 'package:graduation_project_frontend/models/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.api) : super(NotificationInitial());
  final ApiConsumer api;
  List<AppNotification> notifications = [];

  // تحميل الإشعارات من الـ API
  Future<int> loadNotifications(String userId) async {
    emit(NotificationLoading()); // إظهار حالة التحميل

    try {
      final response = await api.get(
        'https://graduation-project-mmih.vercel.app/api/notifications/$userId',
      );

      final responseData = response.data; // الحصول على بيانات الـ response
      print('✅Response Notification: $responseData');

      // تأكد أن الـ response يحتوي على success = true وnotifications موجودة
      if (responseData != null &&
          responseData['success'] == true &&
          responseData['notifications'] != null) {
        final List<dynamic> data = responseData['notifications'];

        // تحويل البيانات إلى قائمة من AppNotification
        final List<AppNotification> loaded =
            data.map((notif) => AppNotification.fromJson(notif)).toList();

        print('✅Parsed Notifications: $loaded');

        notifications = loaded; // حفظ الإشعارات في المتغير
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
      emit(NotificationError(
          'حدث خطأ أثناء تحميل الإشعارات: $e')); // معالجة الخطأ
      print('❌Error loading notifications: $e'); // طباعة الخطأ في الـ console
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

      print(
          '✅Response Mark As Read: ${response}'); // طباعة استجابة تحديث الإشعار

      if (response['status'] == true) {
        print('تم تحديث الإشعار إلى مقروء');
      } else {
        print('فشل في تحديث الإشعار');
      }
    } catch (e) {
      print('خطأ: $e');
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
