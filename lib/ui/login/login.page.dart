import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miss_minutes/ui/login/login.dart';
import 'package:miss_minutes/ui/shared/root.page.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser?.photoURL ?? ''
              ),
            ),
            Text(
              FirebaseAuth.instance.currentUser?.uid ?? ''
            ),
            SignInButton(
              buttonType: ButtonType.google,
              onPressed: () async {
          
                UserCredential? userCredential = await auth.signInWithGoogle();
                
                if(userCredential != null && context.mounted){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder:(context) => RootPage(),)
                  );
                }
              }
            ),

            SignInButton(buttonType: ButtonType.discord, onPressed: (){auth.signOut();})
          ],
        ),
      ),
    );
  }
  
}