import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:loomeive/loomeive.dart';
import 'package:miss_minutes/classes/course.class.dart';
import 'package:miss_minutes/repositories/course.repository.dart';

class CoursesWidget extends StatelessWidget {
  const CoursesWidget({super.key});

  static final CourseRepository _courseRepository = CourseRepository();

  static Future<List<Course>> _getCourses() async {
    return await _courseRepository.getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton.filledTonal(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(LucideIcons.arrowLeft),
                ),
                Expanded(
                  child: Text(
                    tr('settings.courses.title').toSmartSentenceCase,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: () => print("add course"),
                  icon: Icon(LucideIcons.plus),
                ),
              ],
            ),
            FutureBuilder(
              future: _getCourses(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 12,
                    children:
                        snapshot.data
                            ?.map(
                              (course) => Slidable(
                                key: ValueKey(course),
                                endActionPane: ActionPane(
                                  motion: const StretchMotion(),
                                  extentRatio: 1 / 3,
                                  children: [
                                    CustomSlidableAction(
                                      onPressed:
                                          (context) => print("edit $course"),
                                      backgroundColor: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.tertiaryContainer,
                                          child: Center(
                                            child: Icon(
                                              LucideIcons.pen,
                                              color:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onTertiaryContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    CustomSlidableAction(
                                      onPressed:
                                          (context) => print("delete $course"),
                                      backgroundColor: Colors.transparent,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 4),
                                        child: Material(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.errorContainer,
                                          child: Center(
                                            child: Icon(
                                              LucideIcons.trash2,
                                              color:
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .onErrorContainer,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide.none,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.white,
                                  margin: EdgeInsets.zero,
                                  child: ListTile(
                                    title: Text(
                                      course.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(course.location),
                                    leading: Icon(
                                      LucideIcons.waves600,
                                      color:
                                          course.colorHex != null
                                              ? fromHex(
                                                course.colorHex ?? '000000',
                                              )
                                              : null,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  );
                }

                return Center(child: CircularProgressIndicator.adaptive());
              },
            ),
          ],
        ),
      ),
    );
  }
}
