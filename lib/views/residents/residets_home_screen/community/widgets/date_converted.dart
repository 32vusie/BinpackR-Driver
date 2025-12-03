import 'package:intl/intl.dart';

String timeAgo(DateTime timestamp) {
  final Duration diff = DateTime.now().difference(timestamp);

  if (diff.inSeconds < 60) {
    return '${diff.inSeconds}s ago';
  } else if (diff.inMinutes < 60) {
    return '${diff.inMinutes}m ago';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}h ago';
  } else if (diff.inDays < 7) {
    return '${diff.inDays}d ago';
  } else {
    return DateFormat.yMMMd().format(timestamp); // For dates older than a week
  }
}
