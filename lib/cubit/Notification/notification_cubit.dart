import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:radintel/api_services/api_consumer.dart';
import 'package:radintel/models/notification_model.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit(this.api) : super(NotificationInitial());
  final ApiConsumer api;

  final String baseUrl =
      'https://graduation-project--xohomg.fly.dev/api/notifications';
  List<AppNotification> notifications = [];
  List<AppNotification> unreadNotifications = [];
  int totalNotifications = 0;
  int unreadNotificationsCount = 0;

  /// تحميل كل الإشعارات لمستخدم
  Future<void> loadNotifications(String userId) async {
    emit(NotificationLoading());

    try {
      final response = await api.get('$baseUrl/all/$userId');
      final response0 = await api.get('$baseUrl/$userId');
      final responseData = response.data;
      final responseData0 = response0.data;

      if (responseData != null &&
          responseData['success'] == true &&
          responseData['notifications'] != null &&
          responseData0 != null &&
          responseData0['success'] == true &&
          responseData0['notifications'] != null) {
        final List<dynamic> data = responseData['notifications'];
        final List<AppNotification> loaded =
            data.map((notif) => AppNotification.fromJson(notif)).toList();
        notifications = loaded;
        totalNotifications = responseData['count'];
        unreadNotificationsCount = responseData0['count'];

        emit(NotificationLoaded(loaded,
            totalNotifications: totalNotifications,
            unreadNotifications: unreadNotificationsCount));
      } else {
        emit(
            NotificationError('فشل في تحميل الإشعارات أو البيانات غير مكتملة'));
      }
    } catch (e) {
      emit(NotificationError('❌Error loading notifications: $e'));
      print('❌Error loading notifications: $e');
    }
  }

  /// إرسال إشعار
  Future<void> sendNotification(
    String userId,
    String userType,
    String title,
    String message, {
    String type = 'general',
  }) async {
    emit(NotificationSending());

    try {
      final response = await api.post(
        '$baseUrl/send',
        data: {
          'userId': userId,
          'userType': userType,
          'title': title,
          'message': message,
          'type': type,
        },
      );

      print('✅Response Notification Sent: $response');

      if (response['status'] == true) {
        emit(NotificationSent());
      } else {
        emit(NotificationError('فشل في إرسال الإشعار'));
      }
    } catch (e) {
      emit(NotificationError('خطأ: $e'));
    }
  }

  /// جلب تفاصيل إشعار واحد عبر ID
  Future<AppNotification?> getNotificationById(String notificationId) async {
    emit(NotificationLoading());
    try {
      final response = await api.get('$baseUrl/$notificationId');

      final responseData = response.data;
      if (responseData != null && responseData['success'] == true) {
        final AppNotification notification =
            AppNotification.fromJson(responseData['notification']);
        emit(Notificationload(notification));
        return notification;
      } else {
        emit(NotificationError('فشل في تحميل تفاصيل الإشعار'));
        return null;
      }
    } catch (e) {
      emit(NotificationError('❌Error loading notification by ID: $e'));
      print('❌Error loading notification by ID: $e');
      return null;
    }
  }

  /// تعليم إشعار واحد كمقروء
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      final response = await api.put('$baseUrl/read/$notificationId');

      if (response.data['isRead'] == true) {
        print('✅Notification marked as read');
      } else {
        print('❌Failed to mark notification as read');
      }
    } catch (e) {
      print('❌Error marking notification as read: $e');
    }
  }

  /// تحديث إشعار واحد في الواجهة كمقروء
  Future<void> markAsRead(int index, String userId) async {
    final notificationId = notifications[index].id;
    await markNotificationAsRead(notificationId);
    final updatedNotification = notifications[index].copyWith(isRead: true);
    notifications[index] = updatedNotification;
    unreadNotifications = notifications.where((n) => !n.isRead).toList();
    emit(NotificationLoaded(List.from(notifications),
        totalNotifications: totalNotifications,
        unreadNotifications: unreadNotifications.length));
  }

  /// تعليم كل الإشعارات كمقروءة
  Future<void> markAllNotificationsAsRead(String userId) async {
    emit(NotificationLoading());
    try {
      final response = await api.put('$baseUrl/all/read/$userId');

      if (response.data['success'] == true) {
        print('✅All notifications marked as read');
      } else {
        emit(NotificationError('فشل في تعليم كل الإشعارات كمقروءة'));
      }
      loadNotifications(userId);
    } catch (e) {
      emit(NotificationError('❌Error marking all notifications as read: $e'));
      print('❌Error marking all notifications as read: $e');
    }
  }

  /// حذف إشعار واحد
  Future<void> deleteNotification(String notificationId) async {
    emit(NotificationLoading());
    try {
      final response = await api.delete('$baseUrl/$notificationId');

      if (response.data['success'] == true) {
        print('🗑️ Notification deleted');
        notifications.removeWhere((n) => n.id == notificationId);
        unreadNotifications = notifications.where((n) => !n.isRead).toList();
        emit(NotificationLoaded(List.from(notifications),
            totalNotifications: totalNotifications,
            unreadNotifications: unreadNotifications.length));
      } else {
        emit(NotificationError('فشل في حذف الإشعار'));
      }
    } catch (e) {
      emit(NotificationError('❌Error deleting notification: $e'));
      print('❌Error deleting notification: $e');
    }
  }

  /// حذف كل الإشعارات لمستخدم
  Future<void> deleteAllNotifications(String userId) async {
    emit(NotificationLoading());
    try {
      final response = await api.delete('$baseUrl/all/$userId');

      if (response.data['success'] == true) {
        print('🗑️ All notifications deleted');
        notifications.clear();
        unreadNotifications.clear();
        emit(NotificationLoaded([]));
      } else {
        emit(NotificationError('فشل في حذف كل الإشعارات'));
      }
    } catch (e) {
      emit(NotificationError('❌Error deleting all notifications: $e'));
      print('❌Error deleting all notifications: $e');
    }
  }

  Future<void> updataNotifyByType(String userId, String type) async {
    try {
      final response = await api.put('$baseUrl/make_all_read',
          data: {"userId": userId, "type": type});
      if (response.data['success'] == true) {
        print('✅Notification marked as read');
      } else {
        print('❌Failed to mark notification as read');
      }
      loadNotifications(userId);
    } catch (e) {
      print('❌Error marking notification as read: $e');
    }
  }
}
