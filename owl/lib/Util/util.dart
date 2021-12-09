String minutesToStringFormat(int minutes) {
  int hrs = 0, min = 0;
  if (minutes > 59) {
    hrs = (minutes / 60).floor();
    min = (minutes % 60);
    return "$hrs:$min:00";
  } else {
    return "00:$min:00";
  }
}

int smallerThan(int a, int b) {
  if (a <= b) {
    return a;
  } else {
    return b;
  }
}
