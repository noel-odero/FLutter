import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[500],
        toolbarHeight: 100.0,
        title: Text(
          'Welcome Back!!!',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Enter your username',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
