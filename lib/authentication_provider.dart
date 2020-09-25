import 'package:authentication_provider/authentication_state.dart';
import 'package:flutter/material.dart';

import 'authentication_controller.dart';

export 'package:authentication_provider/authentication_controller.dart';
export 'package:authentication_provider/authentication_state.dart';

/// Provides authenticationd data down the widget tree with a user type of [T]
class AuthenticationProvider<T extends Object> extends InheritedWidget {
  final AuthenticationController<T> controller;

  AuthenticationState get state => controller.state;
  set state(AuthenticationState value) => controller.state = value;

  final Widget Function(BuildContext context) builder;

  AuthenticationProvider(
      {@required this.controller, @required this.builder, Key key})
      : super(child: _AuthenticationWidget(builder, controller), key: key);

  @override
  bool updateShouldNotify(AuthenticationProvider oldWidget) {
    return true;
  }

  static AuthenticationProvider of<G>(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AuthenticationProvider<G>>();
  }
}

class _AuthenticationWidget extends StatefulWidget {
  final Widget Function(BuildContext context) builder;
  final AuthenticationController controller;
  _AuthenticationWidget(this.builder, this.controller);

  @override
  __AuthenticationWidgetState createState() => __AuthenticationWidgetState();
}

class __AuthenticationWidgetState extends State<_AuthenticationWidget> {
  @override
  void initState() {
    super.initState();

    widget.controller.stateChanged.listen((state) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}
