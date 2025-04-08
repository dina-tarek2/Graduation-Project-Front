import 'package:intl/intl.dart';

String formatNotificationDate(DateTime date) {
  // إضافة ساعتين
  final updatedDate = date.add(Duration(hours: 2));

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final dateOnly =
      DateTime(updatedDate.year, updatedDate.month, updatedDate.day);

  final difference = today.difference(dateOnly).inDays;

  if (difference == 0) {
    // اليوم
    return DateFormat('hh:mm a', 'en_US').format(updatedDate);
  } else if (difference < 7) {
    // خلال نفس الأسبوع
    return '${DateFormat('EEEE', 'en_US').format(updatedDate)} - ${DateFormat('hh:mm a', 'en_US').format(updatedDate)}';
  } else {
    // أقدم من أسبوع
    return DateFormat('dd MMM yyyy - hh:mm a', 'en_US').format(updatedDate);
  }
}
