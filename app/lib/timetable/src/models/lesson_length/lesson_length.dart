class LessonLength {
  final int minutes;
  bool get isValid => minutes != null && minutes > 0;
  Duration get duration => Duration(minutes: minutes);

  LessonLength(this.minutes);
  LessonLength.standard() : minutes = 45;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LessonLength && other.minutes == minutes;
  }

  @override
  int get hashCode => minutes.hashCode;
}
