import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/classes/course.class.dart';
import 'package:miss_minutes/repositories/course.repository.dart';
import 'package:uuid/uuid.dart';

class AddCoursePage extends StatefulWidget {
  const AddCoursePage({super.key});

  @override
  State<AddCoursePage> createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  late CourseRepository _courseRepository;
  final _formKey = GlobalKey<FormBuilderState>();
  bool isLoading = true;
  final uuid = Uuid();

  List<Map<String, dynamic>> addable = [];

  @override
  void initState() {
    super.initState();
    _courseRepository = CourseRepository();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    final courses = await _courseRepository.getCourses();
    setState(() {
      addable = courses.map(
        (course) => {
          "id" : course.id,
          "name" : course.name,
          "location" : course.location,
          "colorHex" : course.colorHex,
          "firebase" : true,
          "formKey": uuid.v4(),
        }
      ).toList();
      isLoading = false;
    });
  }

  void _deleteFirebaseCourse(String id) {
    _courseRepository.deleteCourse(id);
  }

  Widget _buildFormField({ required Map<String, dynamic> element, required int index }){
    final fieldKey = element['formKey'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: FormBuilderTextField(
            key: ValueKey(fieldKey),
            name: "name_$fieldKey",
            initialValue: element['name'] ?? '',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
          ),
        ),
        Expanded(
          child: FormBuilderTextField(
            key: ValueKey(fieldKey),
            name: "location_$fieldKey",
            initialValue: element['location'] ?? '',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required()
            ]),
          ),
        ),
        IconButton.filledTonal(
          onPressed: () async {
            if (element['firebase'] == true && element['id'] != null) {
              _deleteFirebaseCourse(element['id'].toString());
            }

            setState(() {
              // Rimuove il valore dal form builder
              _formKey.currentState?.removeInternalFieldValue(fieldKey);
              addable.removeAt(index);
            });
          },
          icon: Icon(
            Icons.delete_rounded
          )
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 64.limit(
            MediaQuery.of(context).viewInsets.bottom,
            kBottomNavigationBarHeight / 2
          ) as double,
          left: 16,
          right: 16,
          top: 16
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            isLoading ?
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator()
                ),
              ) : 
              addable.isEmpty ? Text("Nessun elemento") : SizedBox.shrink(),
            ...addable.mapIndexed(
              (index, element) => _buildFormField(
                element: element,
                index: index
              )
            ),
            Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      addable.add({
                        "id": null,
                        "name": null,
                        "location": null,
                        "firebase": false,
                        "formKey": uuid.v4(),
                      });
                    });
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Aggiungi"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final isValid = _formKey.currentState?.saveAndValidate() ?? false;
                    if (isValid) {
                      for (var item in addable) {
                        final fieldKey = item['formKey'];
                        final name = _formKey.currentState?.value["name_$fieldKey"];
                        final location = _formKey.currentState?.value["location_$fieldKey"];
                        final Course courseToAdd = Course(
                          id: item['id'],
                          name: name,
                          location: location,
                          colorHex: item['colorHex'],
                        );
                        item['firebase'] ? _courseRepository.updateCourse(courseToAdd) : _courseRepository.addCourse(courseToAdd);
                      }
                    }
                  },
                  child: const Text("Salva"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}