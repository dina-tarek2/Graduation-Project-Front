import 'package:intl/intl.dart';

String formatNotificationDate(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24 && now.day == dateTime.day) {
    return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
  } else if (difference.inHours < 48 &&
      now.day - dateTime.day == 1 &&
      now.month == dateTime.month) {
    return 'Yesterday at ${DateFormat('h:mm a').format(dateTime)}';
  } else {
    return DateFormat('MMM d at h:mm a').format(dateTime);
  }
}
