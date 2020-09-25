import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'authentication_state.dart' as State;

class AuthenticationController<T> {
  T _user;
  State.AuthenticationState _state;

  State.AuthenticationState get state => _state;
  set state(State.AuthenticationState value) {
    _state = value;
    stateChanged.add(value);
  }

  T get user => _user;
  set user(T value) {
    _user = value;
    userChanged.add(value);
  }

  StreamController stateChanged;
  StreamController userChanged;

  AuthenticationController({State.AuthenticationState initialState}) {
    stateChanged = StreamController();
    userChanged = StreamController();
    state = initialState ?? State.Uninitialized();
  }

  void dispose() {
    stateChanged.close();
    userChanged.close();
  }

  void authenticate({@required T user, dynamic data}) {
    this.state = State.Authenticated<T>(user, data: data);
  }

  void deauthenticate({dynamic data}) {
    this.state = State.Unauthenticated(data: data);
  }

  void loading({dynamic data}) {
    this.state = State.Loading(data: data);
  }
}
