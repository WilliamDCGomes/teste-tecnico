class FormatNumbers {
  static String formatVideoTime(int minutes, int seconds) {
    String formatedMinutes = "";
    String formatedSeconds = "";

    if (minutes < 10) {
      formatedMinutes += "0$minutes";
    } else {
      formatedMinutes += minutes.toString();
    }

    if (seconds < 10) {
      formatedSeconds += "0$seconds";
    } else {
      formatedSeconds += seconds.toString();
    }

    return "$formatedMinutes:$formatedSeconds";
  }
}
