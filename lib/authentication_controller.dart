import 'dart:async';

import 'package:flutter/material.dart';

import 'authentication_state.dart' as State;
import 'authentication_state.dart';

class AuthenticationController<T extends Object> {
  T _user;
  State.AuthenticationState _state;
  BuildContext _context;

  /// Root build context of AuthenticationProvider
  ///
  /// This can be used to show dialogs even after the
  /// state has changed.
  BuildContext get context => _context;

  /// Called when [deauthenticate] is invoked with the root [BuildContext]
  Function(BuildContext context, {dynamic data}) onDeauthenticate;

  /// Called when [authenticate] is invoked with the root [BuildContext]
  Function(BuildContext context, {T user, dynamic data}) onAuthenticate;

  /// Current [AuthenticationState] of the app
  State.AuthenticationState get state => _state;
  set state(State.AuthenticationState value) {
    _state = value;
    _stateStreamController.add(value);
  }

  /// Current [T] of the app
  ///
  /// Will only be filled if passed in authenticate method
  T get user => _user;
  set user(T value) {
    _user = value;
    _userStreamController.add(value);
  }

  Future<State.AuthenticationState> Function() _initialize;

  StreamController<AuthenticationState> _stateStreamController;
  StreamController<T> _userStreamController;

  Stream _stateChanged;
  Stream _userChanged;

  /// Streams a new [AuthenticationState] when the [state] is changed.
  Stream get stateChanged => _stateChanged;

  /// Streams a new [T] when the [user] is changed.
  Stream get userChanged => _userChanged;

  AuthenticationController(BuildContext context,
      {Future<State.AuthenticationState> Function() initialize,
      State.AuthenticationState initialState}) {
    _stateStreamController = StreamController();
    _userStreamController = StreamController();
    state = initialState ?? State.Uninitialized();
    _initialize = initialize;
    _context = context;
    _stateChanged = _stateStreamController.stream.asBroadcastStream();
    _userChanged = _userStreamController.stream.asBroadcastStream();
  }

  /// Should be called whenever the widget that created this [AuthenticationController]
  /// instance is disposed of.
  void dispose() {
    _stateStreamController.close();
    _userStreamController.close();
  }

  /// Called the first time the widget loads
  ///
  /// Allows for async calls, however the initialize function is not required
  /// and this functionality can be implemented in the builder passed to the
  /// [AuthenticationProvider] instead.
  void initialize() async {
    this.state =
        _initialize != null ? await _initialize() : State.Unauthenticated();
  }

  /// Call to change state to [Authenticated]
  void authenticate({T user, dynamic data}) {
    this.state = State.Authenticated<T>(user: user, data: data);
    if (onAuthenticate != null) onAuthenticate(context, user: user, data: data);
  }

  /// Call to change state to [Unauthenticated]
  void deauthenticate({dynamic data}) {
    this.state = State.Unauthenticated(data: data);
    if (onDeauthenticate != null) onDeauthenticate(context, data: data);
  }

  /// Call to change state to [Loading]
  void loading({dynamic data}) {
    this.state = State.Loading(data: data);
  }
}
