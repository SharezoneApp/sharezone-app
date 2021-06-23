import 'package:bloc_base/bloc_base.dart';
import 'package:meta/meta.dart';
import 'package:design/design.dart';
import 'package:sharezone/util/api/courseGateway.dart';

class CourseEditDesignBloc extends BlocBase {
  final String courseId;
  final CourseGateway courseGateway;

  final Stream<Design> courseDesign;
  final Stream<Design> personalDesign;

  CourseEditDesignBloc(this.courseId, this.courseGateway)
      : courseDesign =
            courseGateway.streamCourse(courseId).map((course) => course.design),
        personalDesign = courseGateway
            .streamCourse(courseId)
            .map((course) => course.personalDesign);

  Future<void> submitCourseDesign(
      {@required Design initalDesign, @required Design selectedDesign}) async {
    assert(initalDesign != null && selectedDesign != null,
        "initalDesign and selectedDesign shouldn't be null");

    if (_hasUserChangedDesign(initalDesign, selectedDesign)) {
      await _editCourseDesign(selectedDesign);
    }
  }

  void submitPersonalDesign(
      {Design initalDesign, @required Design selectedDesign}) {
    assert(selectedDesign != null, "selectedDesign shouldn't be null");

    if (_hasUserChangedDesign(initalDesign, selectedDesign)) {
      _editPersonalDeisgn(selectedDesign);
    }
  }

  void removePersonalDesign() {
    courseGateway.removeCoursePersonalDesign(courseId);
  }

  void _editPersonalDeisgn(Design selectedDesign) {
    courseGateway.editCoursePersonalDesign(
        personalDesign: selectedDesign, courseID: courseId);
  }

  Future<bool> _editCourseDesign(Design selectedDesign) async {
    try {
      return await courseGateway.editCourseGeneralDesign(
          courseID: courseId, design: selectedDesign);
    } catch (e) {
      return false;
    }
  }

  bool _hasUserChangedDesign(Design initalDesign, Design selectedDesign) =>
      initalDesign != selectedDesign;

  @override
  void dispose() {}
}
