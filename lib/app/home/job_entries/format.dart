import 'package:intl/intl.dart';

class Format {
  String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  String time(double userTime) {
    int hours = userTime.toInt();

    double decimalMinutes = userTime - hours;
    String formattedDecimalMinutesInString = decimalMinutes.toStringAsFixed(2);
    double formattedDecimalMinutes =
        double.parse(formattedDecimalMinutesInString);
    double convertedMinutes = formattedDecimalMinutes * 60;
    int minutes = convertedMinutes.toInt();

    double decimalSeconds = convertedMinutes - minutes;
    String formattedDecimalSecondsInString = decimalSeconds.toStringAsFixed(2);
    double formattedDecimalSeconds =
        double.parse(formattedDecimalSecondsInString);
    double convertedSeconds = formattedDecimalSeconds * 60;
    int seconds = convertedSeconds.toInt();

    Duration duration =
        Duration(hours: hours, minutes: minutes, seconds: seconds);
    String formatDuration(Duration d) =>
        d.toString().split('.').first.padLeft(8, "0");
    String time = formatDuration(duration);

    List timeList = [];
    RegExp exp = RegExp(r"(\w+)");
    String str = time;
    Iterable<Match> matches = exp.allMatches(str);
    for (Match m in matches) {
      String match = m[0];
      timeList.add(match);
    }
    String myTime =
        '${timeList[0]}h' + ':' + '${timeList[1]}m' + ':' + '${timeList[2]}s';
    return myTime;
  }

  String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }
}
