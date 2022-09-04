import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote/constants/routes.dart';
import 'package:mynote/views/Verify_Email_View.dart';
import 'package:mynote/views/register_view.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoutes: (context) => const Login_view(),
      registerRoutes: (context) => const Register(),
      noteRoutes: (context) => const NoteView(),
      verifyEmailRoute: (context) => const VerifyEmailView()
    },
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
            user?.reload();
            if (user != null) {
              if (user.emailVerified == true) {
                return const NoteView();
              } else {
                return const VerifyEmailView();
              }
            } else {
              return const Login_view();
            }
          default:
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              strokeWidth: 5.0,
            ));
        }
      },
    );
  }
}

enum MenuAction { Logout }

class NoteView extends StatefulWidget {
  const NoteView({Key? key}) : super(key: key);

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.Logout:
                final shoudLogout = await showLogoutDialog(context);
                if (shoudLogout) {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoutes, (route) => false);
                }
            }
          }, itemBuilder: (context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.Logout,
                child: Text('Log out'),
              ),
            ];
          })
        ],
        centerTitle: true,
        title: const Text('Main Ui'),
      ),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Log out conformation'),
          content: const Text('Are you sure do you want to log out ?'),
          actions: [
            TextButton(
              onPressed: () {
                return Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                return Navigator.of(context).pop(true);
              },
              child: const Text('Log out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}
