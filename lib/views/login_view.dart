import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mynote/constants/routes.dart';
import '../firebase_options.dart';

class Login_view extends StatefulWidget {
  const Login_view({Key? key}) : super(key: key);

  @override
  State<Login_view> createState() => _Login_viewState();
}

class _Login_viewState extends State<Login_view> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _password.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30.0),
        padding: const EdgeInsets.all(30),
        child: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return Column(
                  children: [
                    const SizedBox(height: 15.0),
                    emailField(),
                    const SizedBox(height: 8.0),
                    passwordField(),
                    const SizedBox(height: 8.0),
                    btnLogin(),
                    btnNotUser()
                  ],
                );
              default:
                return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget btnLogin() {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
        ),
        onPressed: () async {
          final email = _email.text;
          final password = _password.text;
          try {
            final userCredential =
                await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: email,
              password: password,
            );
            if (!mounted) return;
            Navigator.of(context).pushNamedAndRemoveUntil(
              noteRoutes,
              (route) => false,
            );
          } on FirebaseAuthException catch (e) {
            //print(e.code);
            //if (e.code == 'user-not-found') {
            showErrorDialog(context, e.code);
            // print(e.runtimeType);
            //} else if (e.code == 'wrong-password') {
            //  print(e.code);
            //  print('Wrong Password');
            // } else if (e.code == 'unknown') {
            // print('please Fill out');
            // }
          }
        },
        child: const Text('Login'),
      ),
    );
  }

  Widget btnNotUser() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(registerRoutes, (route) => false);
        },
        child: const Text('Do you Have a Account? Register Here.'),
      ),
    );
  }

  Widget emailField() {
    return TextField(
      controller: _email,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email Address',
        hintText: 'ravindu@gmail.com',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  Widget passwordField() {
    return TextField(
      controller: _password,
      obscureText: true,
      autocorrect: false,
      enableSuggestions: false,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'password',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

Future<void> showErrorDialog(BuildContext context, String text) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error Occurred'),
          content: Text(text),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Ok'))
          ],
        );
      });
}
