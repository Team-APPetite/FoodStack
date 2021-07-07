class TimeHelper {
  static int minutesRemaining(DateTime time) {
    DateTime currentTime = DateTime.now();
    int minutes;
    if (time.hour > currentTime.hour) {
      minutes = 60 - (currentTime.minute - time.minute);
    } else {
      minutes = time.minute - currentTime.minute;
    }
    return minutes;
  }
}  