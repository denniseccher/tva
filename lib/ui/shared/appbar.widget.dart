import 'package:duration_picker/duration_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
import 'package:miss_minutes/bloc/shifts/shifts.bloc.dart';
import 'package:miss_minutes/ui/add_course/add_course.page.dart';
import 'package:miss_minutes/ui/add_price/add_price.page.dart';
import 'package:miss_minutes/ui/login/login.dart';
import 'package:miss_minutes/ui/shared/root.page.dart';
import 'package:miss_minutes/utilities/functions.utility.dart';
import 'package:miss_minutes/utilities/open_modal.utility.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

PreferredSizeWidget evAppBar({ required BuildContext context, required ShiftBloc shiftBloc }){
  return AppBar(
    scrolledUnderElevation: 0,
    leading: Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 8,
        top: 8,
        bottom: 8
      ),
      child: InkWell(
        onTap: () {
          openModal(
            context: context,
            returnWidget: ListView(
              shrinkWrap: true,
              children: [

                ListTile(
                  title: Text("Corsi"),
                  onTap: () {
                    openModal(context: context, returnWidget: AddCoursePage());
                  },
                  leading: Icon(
                    Icons.school_rounded
                  ),
                ),

                ListTile(
                  title: Text("Prezzi"),
                  onTap: () {
                    openModal(context: context, returnWidget: AddPricePage());
                  },
                  leading: Icon(
                    Icons.euro_rounded
                  ),
                ),

                ListTile(
                  iconColor: Colors.red,
                  textColor: Colors.red,
                  leading: Icon(Icons.logout),
                  title: Text("Logout"),
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    AuthService().signOut();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder:(context) => RootPage(),)
                    );
                  },
                ),

                
              ],
            )
          );
        },
        child: CircleAvatar(
          foregroundImage: NetworkImage(
            FirebaseAuth.instance.currentUser?.photoURL ?? ''
          ),
          backgroundColor: Color(0xFFFF6600),
        ),
      ),
    ),
    leadingWidth: 16 + 8 + 40,
    centerTitle: false,
    titleSpacing: 0,
    actionsPadding: EdgeInsets.only(
      right: 8
    ),
    actions: [
      IconButton(
        onPressed: () => openSheet(context: context, bloc: shiftBloc, type: "email"),
        icon: GradientIcon(
          size: 24,
          offset: Offset(0, 0),
          icon: Icons.email_outlined,
          gradient: LinearGradient(
            stops: [
              0,
              0.25
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red,
              Color(0xFFFF6600)
            ],
          )
        ),
      ),
      IconButton(
        onPressed: () => openSheet(context: context, bloc: shiftBloc, type: "save"),
        icon: GradientIcon(
          size: 24,
          offset: Offset(0, 0),
          icon: Icons.download_rounded,
          gradient: LinearGradient(
            stops: [
              0,
              0.25
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.red,
              Color(0xFFFF6600)
            ],
          )
        ),
      )
    ],
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GradientText(
          "Ciao ${FirebaseAuth.instance.currentUser?.displayName}",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500
          ),
          colors: [
            Colors.red,
            Color(0xFFFF6600)
          ],
        ),
        Text(
          "CSI Trento Nuoto",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            // color: Colors.white
          ),
        )
      ],
    ),
  );
}