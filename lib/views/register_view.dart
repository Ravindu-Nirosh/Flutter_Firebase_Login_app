import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynote/constants/routes.dart';
import '../firebase_options.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
        title: const Text('Register'),
        centerTitle: true,
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
                    confirmEmail(),
                    const SizedBox(height: 8.0),
                    passwordField(),
                    const SizedBox(height: 8.0),
                    btnRegister(),
                    btnReturnLogin()
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Widget btnReturnLogin() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(loginRoutes, (route) => false);
        },
        child: const Text('Already Have an Account? Login Here'),
      ),
    );
  }

  Widget btnRegister() {
    return Center(
      child: TextButton(
        style: TextButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
        ),
        onPressed: () async {
          final email = _email.text;
          final password = _password.text;
          final userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);
          print(userCredential);
        },
        child: const Text('Register'),
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

  Widget confirmEmail() {
    return TextField(
      controller: _email,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Confirm Email Address',
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
