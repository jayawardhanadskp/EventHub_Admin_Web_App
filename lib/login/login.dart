import 'package:eventhub_admin/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  allowAdminToLogin () async {

    SnackBar snackBar = const SnackBar(
      content: Text(
        "Loading.. " ,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
      backgroundColor: Colors.white38,
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    User? currentAdmin;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text
    ).then((fAuth){
      currentAdmin = fAuth.user;
    }).catchError((onError){
      //error massage
      final snackBar = SnackBar(
        content: Text(
          "Error Occurd: " + onError.toString(),
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.white38,
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      // check firestore
      await FirebaseFirestore.instance
          .collection('admin')
          .doc(currentAdmin!.uid)
          .get().then((snap) {

            if (snap.exists) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
            }
            else {
              SnackBar snackBar = const SnackBar(
                content: Text(
                  "No Record Found ",
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
                backgroundColor: Colors.white38,
                duration: Duration(seconds: 5),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: 600,
            child: Image.asset('assets/1.png'),
          ),
          const Divider(
            thickness: 5,
            color: Colors.black45,
          ),
          Container(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Container(
                        child: Column(
                          children: [
                            const Text(
                              'Log In as Admin',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black38,
                              ),
                            ),
                            const SizedBox(height: 40),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter your password',
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            ElevatedButton(
                              onPressed: () {
                                allowAdminToLogin();
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                fixedSize: const Size(350, 60),
                                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                              ),
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
