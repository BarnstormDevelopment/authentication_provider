import 'package:flutter/material.dart';

import 'package:authentication_provider/authentication_controller.dart';
import 'package:authentication_provider/authentication_state.dart' as AuthState;
import 'package:authentication_provider/authentication_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationController controller;

  @override
  void initState() {
    super.initState();
    controller = AuthenticationController<User>(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: AuthenticationProvider<User>(
            controller: controller,
            builder: (context) {
              var state = AuthenticationProvider.of<User>(context).state;
              if (state is AuthState.Loading) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Loading'),
                  ),
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is AuthState.Unauthenticated) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Unauthenticated'),
                  ),
                  body: Center(
                    child: Column(children: [
                      Text('Woops, you are not authenticated.'),
                      TextButton(
                        child: Text('Sign In'),
                        onPressed: () => controller.authenticate(user: User()),
                      )
                    ]),
                  ),
                );
              } else if (state is AuthState.Authenticated<User>) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Authenticated'),
                  ),
                  body: Center(
                    child: Column(children: [
                      Text(
                          'Congratulations, you (${state.user.name}) are authenticated.'),
                      TextButton(
                        child: Text('Log Out'),
                        onPressed: () => controller.deauthenticate(),
                      )
                    ]),
                  ),
                );
              }
              Future.delayed(Duration(seconds: 1), () {
                controller.initialize();
              });
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Uninitialized'),
                ),
                body: Center(
                  child: Text(''),
                ),
              );
            }));
  }
}

class User {
  String name = 'Nathaniel';
}
