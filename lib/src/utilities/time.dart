class TimeHelper {
  static int minutesRemaining(DateTime completionTime, DateTime currTime) {
    var difference = completionTime.difference(currTime);
    int minutes = difference.inMinutes;

    // int minutes;
    // if (completionTime.hour > currTime.hour) {
    //   minutes = 60 - (currTime.minute - completionTime.minute);
    // } else {
    //   minutes = completionTime.minute - currTime.minute;
    // }
    return minutes;
  }
}
  