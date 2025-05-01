import 'package:miss_minutes/api/classes/api.course.class.dart';
import 'package:miss_minutes/api/services/api.course.service.dart';
import 'package:miss_minutes/classes/course.class.dart';

class CourseRepository{
  final ApiCourseService _apiCourseService = ApiCourseService();

  Future<List<Course>> getCourses() async{
    final List<ApiCourse> apiCourses = await _apiCourseService.getCourses();
    return apiCourses.map((apiCourse) => Course.fromApi(apiCourse)).toList();
  }

  void addCourse(Course newCourse){
    _apiCourseService.addCourse(ApiCourse.fromMain(newCourse));
  }

  void deleteCourse(String id){
    _apiCourseService.deleteCourse(id);
  }

  void updateCourse(Course newCourse){
    _apiCourseService.updateCourse(ApiCourse.fromMain(newCourse));
  }
}