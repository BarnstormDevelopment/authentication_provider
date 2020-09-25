import 'package:authentication_provider/authentication_state.dart';
import 'package:flutter/material.dart';

import 'authentication_controller.dart';

/// Provides authenticationd data down the widget tree with a user type of [T]
class AuthenticationProvider<T> extends InheritedWidget {
  final AuthenticationController<T> controller;

  AuthenticationState get state => controller.state;
  set state(AuthenticationState value) => controller.state = value;

  T get user => controller.user;
  set user(T value) => controller.user = value;

  final Widget Function(BuildContext context, AuthenticationState state)
      builder;

  AuthenticationProvider(
      {@required this.controller, @required this.builder, Key key})
      : super(child: _AuthenticationWidget(builder), key: key);

  @override
  bool updateShouldNotify(AuthenticationProvider oldWidget) {
    return true;
  }

  static AuthenticationProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthenticationProvider>();
  }
}

class _AuthenticationWidget extends StatefulWidget {
  final Widget Function(BuildContext context, AuthenticationState state)
      builder;
  _AuthenticationWidget(this.builder);
  @override
  __AuthenticationWidgetState createState() => __AuthenticationWidgetState();
}

class __AuthenticationWidgetState extends State<_AuthenticationWidget> {
  AuthenticationProvider get provider => AuthenticationProvider.of(context);
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, provider.state);
  }
}
