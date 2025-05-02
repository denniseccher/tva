import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:loomeive/extensions/num.extension.dart';
import 'package:miss_minutes/classes/course.class.dart';
import 'package:miss_minutes/repositories/course.repository.dart';

class AddCoursePage extends StatefulWidget{
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  late CourseRepository _courseRepository;
  late final List<Map<String, dynamic>> _courses = [];
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();
    _courseRepository = CourseRepository();
  }

  void _saveForm() {
    if(_formKey.currentState?.saveAndValidate() ?? false){
      final formData = _formKey.currentState?.value;

      if(formData == null) return;

      List<Map<String, dynamic>> processedRows = [];
      List<Course> _newCourses = [];

      for(var row in _courses){
        var rowId = row["key"];
        String? name = formData["name_$rowId"];
        String? location = formData["location_$rowId"];

        try{
          Course newCourse = Course(
            id: null,
            name: name ?? '',
            location: location ?? '',
            colorHex: null
          );

          _newCourses.add(newCourse);
        }catch (e){
          debugPrint("Errore $e");
        }

        processedRows.add({
          "id" : rowId,
          "name" : name,
          "location" : location
        });
      }

      _courseRepository.addCourse(
        _newCourses.first
      );
    }
  }

  Widget buildCourseRow({ required int key, Course? course }){
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: FormBuilderTextField(
            name: "name_$key",
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
            initialValue: course?.name,
          ),
        ),
        Expanded(
          child: FormBuilderTextField(
            name: "location_$key",
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
            initialValue: course?.location,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _courseRepository.getCourses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print(snapshot.data);
          for(int i = 0; i < (snapshot.data?.length ?? 0); i++){
            _courses.add({
              "key" : i,
              "course" : snapshot.data?.elementAt(i)
            });
          }
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom.limit(kBottomNavigationBarHeight / 2, double.infinity).toDouble(),
            ),
            child: Column(
              children: [
                FormBuilder(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: _courses.map(
                      (course) => buildCourseRow(
                        key: course['key'],
                        course: course['course']
                      )
                    ).toList(),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: (){
                        setState(() {
                          _courses.add({
                            "key" : _courses.length,
                            "course" : null
                          });
                        });
                      },
                      child: Text(
                        "Crea corso"
                      )
                    ),

                    ElevatedButton(
                      onPressed: (){
                        if(_formKey.currentState?.validate() ?? false){
                          _saveForm();
                        }
                      },
                      child: Text(
                        "Salva"
                      )
                    )
                  ],
                )
              ],
            ),
          );
        }

        return SizedBox(
          height: 64 + kBottomNavigationBarHeight,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: kBottomNavigationBarHeight
            ),
            child: Center(
              child: CircularProgressIndicator()
            ),
          )
        );
      }
    );
  }
}