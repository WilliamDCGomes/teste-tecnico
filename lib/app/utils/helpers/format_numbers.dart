class FormatNumbers {
  static String formatVideoTime(int seconds) {
    String formatedMinutes = "";
    String formatedSeconds = "";
    int minutes = 0;
    while(seconds > 59){
      minutes++;
      seconds -= 60;
    }

    if (minutes < 10) {
      formatedMinutes += "0$minutes";
    } else {
      formatedMinutes += minutes.toString().substring(0, 2);
    }

    if (seconds < 10) {
      formatedSeconds += "0$seconds";
    } else {
      formatedSeconds += seconds.toString().substring(0, 2);
    }

    return "$formatedMinutes:$formatedSeconds";
  }
}
