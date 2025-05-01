import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miss_minutes/ui/login/login.dart';
import 'package:sign_button/sign_button.dart';

class LoginPage extends StatelessWidget{
  LoginPage({super.key});

  AuthService auth = AuthService();

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
                // AuthService().signOut();
            
                UserCredential? userCredential = await auth.signInWithGoogle();
                
                print(
                  "Username: ${userCredential?.user?.uid}"
                );
              }
            ),

            SignInButton(buttonType: ButtonType.discord, onPressed: (){auth.signOut();})
          ],
        ),
      ),
    );
  }
  
}