import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loomeive/loomeive.dart';
import 'package:loomeive/widgets/menu.widget.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/ui/add_course/add_course.page.dart';
import 'package:miss_minutes/ui/add_price/add_price.page.dart';
import 'package:miss_minutes/ui/settings/settings.page.dart';
import 'package:miss_minutes/ui/login/login.dart';
import 'package:miss_minutes/ui/shared/root.page.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';
import 'package:miss_minutes/utilities/open_modal.utility.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

PreferredSizeWidget evAppBar({
  required BuildContext context,
  required ShiftBloc shiftBloc,
}) {
  return AppBar(
    scrolledUnderElevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(left: 16, right: 8, top: 8, bottom: 8),
      child: InkWell(
        onTap: () {
          openModal(
            context: context,
            returnWidget: ListView(
              padding: EdgeInsets.only(
                left: 8,
                right: 8,
                top: 0,
                bottom: kBottomNavigationBarHeight / 2,
              ),
              shrinkWrap: true,
              children: [
                ListTile(
                  title: Text("Corsi"),
                  onTap: () {
                    openModal(context: context, returnWidget: AddCoursePage());
                  },
                  leading: Icon(Icons.school_rounded),
                ),

                ListTile(
                  title: Text("Prezzi"),
                  onTap: () {
                    openModal(context: context, returnWidget: AddPricePage());
                  },
                  leading: Icon(Icons.euro_rounded),
                ),

                ListTile(
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    AuthService().signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => RootPage()),
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
        child: CircleAvatar(
          foregroundImage: NetworkImage(
            FirebaseAuth.instance.currentUser?.photoURL ?? '',
          ),
          backgroundColor: Color(0xFFFF6600),
        ),
      ),
    ),
    leadingWidth: 16 + 8 + 40,
    centerTitle: false,
    titleSpacing: 0,
    actionsPadding: EdgeInsets.only(right: 8),
    actions: [
      IconButton(
        onPressed: () {
          // TODO apri bottom sheet con menu
          showModalBottomSheet(
            showDragHandle: true,
            isScrollControlled: true,
            context: context,
            builder:
                (context) => MenuWidget(
                  menuSections: [
                    MenuSection(
                      items: [
                        MenuItem(
                          label: 'email',
                          icon: Icon(LucideIcons.mail),
                          onTap:
                              () => openSheet(
                                context: context,
                                bloc: shiftBloc,
                                type: "email",
                              ),
                        ),
                        MenuItem(
                          label: 'save',
                          icon: Icon(LucideIcons.download),
                          onTap:
                              () => openSheet(
                                context: context,
                                bloc: shiftBloc,
                                type: "save",
                              ),
                        ),
                      ],
                    ),
                    MenuSection(
                      items: [
                        MenuItem(
                          label: 'impostazioni',
                          icon: Icon(LucideIcons.pencilRuler),
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SettingsPage(),
                                ),
                              ),
                        ),
                      ],
                    ),
                    MenuSection(
                      items: [
                        MenuItem(
                          label: 'logout',
                          icon: Icon(LucideIcons.logOut),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            AuthService().signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => RootPage(),
                                ),
                              );
                            }
                          },
                          type: Type.warning,
                        ),
                      ],
                    ),
                  ],
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                ),
          );
        },
        icon: Icon(LucideIcons.menu),
      ),
    ],
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          "Ciao ${FirebaseAuth.instance.currentUser?.displayName}",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          colors: [Colors.red, Color(0xFFFF6600)],
        ),
        Text(
          "CSI Trento Nuoto",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            // color: Colors.white
          ),
        ),
      ],
    ),
  );
}
