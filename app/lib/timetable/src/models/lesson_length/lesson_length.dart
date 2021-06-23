class LessonLength {
  final int minutes;
  bool get isValid => minutes != null && minutes > 0;
  Duration get duration => Duration(minutes: minutes);

  LessonLength(this.minutes);
  LessonLength.standard() : minutes = 45;
}
