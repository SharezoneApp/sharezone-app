class HomeworkPageStatus {
  final int nrOfOpenHomeworks;
  final int nrOfCompletedHomeworks;
  HomeworkPageStatus(this.nrOfOpenHomeworks, this.nrOfCompletedHomeworks);
  HomeworkPageStatus.empty()
      : nrOfCompletedHomeworks = 0,
        nrOfOpenHomeworks = 0;
  bool get hasCompletedHomeworks => nrOfCompletedHomeworks > 0;
  bool get hasOpenHomeworks => nrOfOpenHomeworks > 0;

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        other is HomeworkPageStatus &&
            nrOfCompletedHomeworks == other.nrOfCompletedHomeworks &&
            nrOfOpenHomeworks == other.nrOfOpenHomeworks;
  }

  @override
  int get hashCode => nrOfOpenHomeworks ^ nrOfCompletedHomeworks;
}
