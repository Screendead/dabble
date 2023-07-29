toClosestTimeUnit(num minutes) {
  minutes = minutes.round();
  return minutes < 60
      ? '$minutes min'
      : '${minutes ~/ 60} hr${minutes % 60 == 0 ? '' : ' ${minutes % 60} min'}';
}
