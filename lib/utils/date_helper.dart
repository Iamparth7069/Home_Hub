import 'package:intl/intl.dart';

class DateFormatUtil {
  static String formatTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else if (difference.inDays >= 1) {
      // Check if same day
      if (now.day == time.day &&
          now.month == time.month &&
          now.year == time.year) {
        final formatter =
            DateFormat('h:mm a'); // 'h' for 12-hour format, 'a' for AM/PM
        return formatter.format(time);
      } else {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      }
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} min${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }
}
