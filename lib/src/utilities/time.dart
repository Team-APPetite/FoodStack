class TimeHelper {
  static int minutesRemaining(DateTime completionTime, DateTime currTime) {
    var difference = completionTime.difference(currTime);
    int minutes = difference.inMinutes;
    return minutes;
  }

  static int secondsRemaining(DateTime completionTime, DateTime currTime) {
    var difference = completionTime.difference(currTime);
    int seconds = difference.inSeconds;
    return seconds;
  }

  static String formatTime(DateTime time) {
    if (time.minute > 9) {
      return '${time.hour}:${time.minute}';
    } else {
      return '${time.hour}:0${time.minute}';
    }
  }
}
